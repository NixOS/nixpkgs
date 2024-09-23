{ stdenv
, lib
, fetchFromGitHub
, cmake
, wrapGAppsHook3
, readline
, ncurses
, zlib
, gsl
, openmp
, graphicsmagick
, fftw
, fftwFloat
, fftwLongDouble
, proj
, shapelib
, expat
, udunits
, eigen
, pslib
, libpng
, plplot
, libtiff
, libgeotiff
, libjpeg
  # eccodes is broken on darwin
, enableGRIB ? stdenv.isLinux
, eccodes
, enableGLPK ? stdenv.isLinux
, glpk
  # We enable it in hdf4 and use libtirpc as a dependency here from the passthru
  # of hdf4
, enableLibtirpc ? stdenv.isLinux
, libtirpc
, python3
, enableMPI ? (stdenv.isLinux || stdenv.isDarwin)
  # Choose MPICH over OpenMPI because it currently builds on AArch and Darwin
, mpi
  # Unfree optional dependency for hdf4 and hdf5
, enableSzip ? false
, szip
, enableHDF4 ? true
, hdf4
, hdf4-forced ? null
, enableHDF5 ? true
  # HDF5 format version (API version) 1.10 and 1.12 is not fully compatible
  # Specify if the API version should default to 1.10
  # netcdf currently depends on hdf5 with `usev110Api=true`
  # If you wish to use HDF5 API version 1.12 (`useHdf5v110Api=false`),
  # you will need to turn NetCDF off.
, useHdf5v110Api ? true
, hdf5
, hdf5-forced ? null
, enableNetCDF ? true
, netcdf
, netcdf-forced ? null
, plplot-forced ? null
  # wxWidgets is preferred over X11 for this project but we only have it on Linux
  # and Darwin.
, enableWX ? (stdenv.isLinux || stdenv.isDarwin)
, wxGTK32
, Cocoa
  # X11: OFF by default for platform consistency. Use X where WX is not available
, enableXWin ? (!stdenv.isLinux && !stdenv.isDarwin)
}:

let
  hdf4-custom =
    if hdf4-forced != null
    then hdf4-forced
    else
      hdf4.override {
        uselibtirpc = enableLibtirpc;
        szipSupport = enableSzip;
        inherit szip;
      };
  hdf5-custom =
    if hdf5-forced != null
    then hdf5-forced
    else
      hdf5.override ({
        usev110Api = useHdf5v110Api;
        mpiSupport = enableMPI;
        inherit mpi;
        szipSupport = enableSzip;
        inherit szip;
      } // lib.optionalAttrs enableMPI {
        cppSupport = false;
      });
  netcdf-custom =
    if netcdf-forced != null
    then netcdf-forced
    else
      netcdf.override {
        hdf5 = hdf5-custom;
      };
  enablePlplotDrivers = enableWX || enableXWin;
  plplot-with-drivers =
    if plplot-forced != null
    then plplot-forced
    else
      plplot.override {
        inherit
          enableWX
          enableXWin
          ;
      };
in
stdenv.mkDerivation rec {
  pname = "gnudatalanguage";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "gdl";
    rev = "v${version}";
    sha256 = "sha256-IrCLL8MQp0SkWj7sbfZlma5FrnMbgdl4E/1nPGy0Y60=";
  };

  buildInputs = [
    readline
    ncurses
    zlib
    gsl
    openmp
    graphicsmagick
    fftw
    fftwFloat
    fftwLongDouble
    proj
    shapelib
    expat
    mpi
    udunits
    eigen
    pslib
    libpng
    libtiff
    libgeotiff
    libjpeg
    hdf4-custom
    hdf5-custom
    netcdf-custom
    plplot-with-drivers
  ] ++ lib.optional enableXWin plplot-with-drivers.libX11
  ++ lib.optional enableGRIB eccodes
  ++ lib.optional enableGLPK glpk
  ++ lib.optional enableWX wxGTK32
  ++ lib.optional (enableWX && stdenv.isDarwin) Cocoa
  ++ lib.optional enableMPI mpi
  ++ lib.optional enableLibtirpc hdf4-custom.libtirpc
  ++ lib.optional enableSzip szip;

  propagatedBuildInputs = [
    (python3.withPackages (ps: with ps; [ numpy ]))
  ];

  nativeBuildInputs = [
    cmake
  ] ++ lib.optional enableWX wrapGAppsHook3;

  cmakeFlags = lib.optional (!enableHDF4) "-DHDF=OFF"
    ++ [ (if enableHDF5 then "-DHDF5DIR=${hdf5-custom}" else "-DHDF5=OFF") ]
    ++ lib.optional (!enableNetCDF) "-DNETCDF=OFF"
    ++ lib.optional (!enablePlplotDrivers) "-DINTERACTIVE_GRAPHICS=OFF"
    ++ lib.optional (!enableGRIB) "-DGRIB=OFF"
    ++ lib.optional (!enableGLPK) "-DGLPK=OFF"
    ++ lib.optional (!enableWX) "-DWXWIDGETS=OFF"
    ++ lib.optional enableSzip "-DSZIPDIR=${szip}"
    ++ lib.optionals enableXWin [ "-DX11=ON" "-DX11DIR=${plplot-with-drivers.libX11}" ]
    ++ lib.optionals enableMPI [ "-DMPI=ON" "-DMPIDIR=${mpi}" ];

  # Tests are failing on Hydra:
  # ./src/common/dpycmn.cpp(137): assert ""IsOk()"" failed in GetClientArea(): invalid wxDisplay object
  doCheck = stdenv.isLinux;

  # Opt-out unstable tests
  # https://github.com/gnudatalanguage/gdl/issues/482
  # https://github.com/gnudatalanguage/gdl/issues/1079
  # https://github.com/gnudatalanguage/gdl/issues/460
  preCheck = ''
    checkFlagsArray+=("ARGS=-E '${lib.concatMapStringsSep "|" (test: test + ".pro") [
      "test_byte_conversion"
      "test_bytscl"
      "test_call_external"
      "test_tic_toc"
      "test_timestamp"
    ]}'")
  '';

  passthru = {
    hdf4 = hdf4-custom;
    hdf5 = hdf5-custom;
    netcdf = netcdf-custom;
    plplot = plplot-with-drivers;
    python = python3;
    inherit
      enableMPI
      mpi
      useHdf5v110Api
      enableSzip
      enableWX
      enableXWin
      ;
  };

  meta = with lib; {
    description = "Free incremental compiler of IDL";
    longDescription = ''
      GDL (GNU Data Language) is a free/libre/open source incremental compiler
      compatible with IDL (Interactive Data Language) and to some extent with PV-WAVE.
      GDL is aimed as a drop-in replacement for IDL.
    '';
    homepage = "https://github.com/gnudatalanguage/gdl";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ShamrockLee ];
    platforms = platforms.all;
    mainProgram = "gdl";
  };
}
