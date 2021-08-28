{ lib, stdenv
, fetchurl
, hdf5
, m4
, curl # for DAP
, removeReferencesTo
}:

let
  mpiSupport = hdf5.mpiSupport;
  mpi = hdf5.mpi;
in stdenv.mkDerivation rec {
  pname = "netcdf";
  version = "4.7.4";

  src = fetchurl {
    url = "https://www.unidata.ucar.edu/downloads/netcdf/ftp/${pname}-c-${version}.tar.gz";
    sha256 = "1a2fpp15a2rl1m50gcvvzd9y6bavl6vjf9zzf63sz5gdmq06yiqf";
  };

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
    mpiSupport = mpiSupport;
    inherit mpi;
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
