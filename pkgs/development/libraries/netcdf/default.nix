{ lib, stdenv
, fetchurl, unzip
, hdf5
, bzip2
, libzip
, zstd
, szipSupport ? false
, szip
, libxml2
, m4
, curl # for DAP
, removeReferencesTo
}:

let
  inherit (hdf5) mpiSupport mpi;
in stdenv.mkDerivation rec {
  pname = "netcdf" + lib.optionalString mpiSupport "-mpi";
  version = "4.9.0";

  src = fetchurl {
    url = "https://downloads.unidata.ucar.edu/netcdf-c/${version}/netcdf-c-${version}.tar.gz";
    hash = "sha256-TJVgIrecCOXhTu6N9RsTwo5hIcK35/qtwhs3WUlAC0k=";
  };

  postPatch = ''
    patchShebangs .

    # this test requires the net
    for a in ncdap_test/Makefile.am ncdap_test/Makefile.in; do
      substituteInPlace $a --replace testurl.sh " "
    done
  '';

  nativeBuildInputs = [ m4 removeReferencesTo ];

  buildInputs = [
    curl
    hdf5
    libxml2
    mpi
    bzip2
    libzip
    zstd
  ] ++ lib.optional szipSupport szip;

  passthru = {
    inherit mpiSupport mpi;
  };

  configureFlags = [
      "--enable-netcdf-4"
      "--enable-dap"
      "--enable-shared"
      "--disable-dap-remote-tests"
      "--with-plugin-dir=${placeholder "out"}/lib/hdf5-plugins"
  ]
  ++ (lib.optionals mpiSupport [ "--enable-parallel-tests" "CC=${mpi}/bin/mpicc" ]);

  enableParallelBuilding = true;

  disallowedReferences = [ stdenv.cc ];

  postFixup = ''
    remove-references-to -t ${stdenv.cc} "$(readlink -f $out/lib/libnetcdf.settings)"
  '';

  doCheck = !(mpiSupport || (stdenv.isDarwin && stdenv.isAarch64));
  nativeCheckInputs = [ unzip ];

  preCheck = ''
    export HOME=$TEMP
  '';

  meta = {
    description = "Libraries for the Unidata network Common Data Format";
    platforms = lib.platforms.unix;
    homepage = "https://www.unidata.ucar.edu/software/netcdf/";
    changelog = "https://docs.unidata.ucar.edu/netcdf-c/${version}/RELEASE_NOTES.html";
    license = lib.licenses.bsd3;
  };
}
