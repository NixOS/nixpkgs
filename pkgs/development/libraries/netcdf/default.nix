{ lib, stdenv
, fetchpatch
, fetchurl
, hdf5
, m4
, curl # for DAP
, removeReferencesTo
}:

let
  inherit (hdf5) mpiSupport mpi;
in stdenv.mkDerivation rec {
  pname = "netcdf" + lib.optionalString mpiSupport "-mpi";
  version = "4.8.0"; # Remove patch mentioned below on upgrade

  src = fetchurl {
    url = "https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-${version}.tar.gz";
    sha256 = "1mfn8qi4k0b8pyar3wa8v0npj69c7rhgfdlppdwmq5jqk88kb5k7";
  };

  patches = [
    # Fixes:
    #     *** Checking vlen of compound file...Sorry! Unexpected result, tst_h_atts3.c, line: 289
    #     FAIL tst_h_atts3 (exit status: 2)
    # TODO: Remove with next netcdf release (see https://github.com/Unidata/netcdf-c/pull/1980)
    (fetchpatch {
      name = "netcdf-Fix-tst_h_atts3-for-hdf5-1.12.patch";
      url = "https://github.com/Unidata/netcdf-c/commit/9fc8ae62a8564e095ff17f4612874581db0e4db5.patch";
      sha256 = "128kxz5jikq32x5qjmi0xdngi0k336rf6bvbcppvlk5gibg5nk7v";
    })
  ];

  postPatch = ''
    patchShebangs .

    # this test requires the net
    for a in ncdap_test/Makefile.am ncdap_test/Makefile.in; do
      substituteInPlace $a --replace testurl.sh " "
    done
  '';

  nativeBuildInputs = [ m4 removeReferencesTo ];
  buildInputs = [ hdf5 curl mpi ];

  passthru = {
    inherit mpiSupport mpi;
  };

  configureFlags = [
      "--enable-netcdf-4"
      "--enable-dap"
      "--enable-shared"
      "--disable-dap-remote-tests"
  ]
  ++ (lib.optionals mpiSupport [ "--enable-parallel-tests" "CC=${mpi}/bin/mpicc" ]);

  disallowedReferences = [ stdenv.cc ];

  postFixup = ''
    remove-references-to -t ${stdenv.cc} "$(readlink -f $out/lib/libnetcdf.settings)"
  '';

  doCheck = !mpiSupport;

  meta = {
      description = "Libraries for the Unidata network Common Data Format";
      platforms = lib.platforms.unix;
      homepage = "https://www.unidata.ucar.edu/software/netcdf/";
      license = {
        url = "https://www.unidata.ucar.edu/software/netcdf/docs/copyright.html";
      };
  };
}
