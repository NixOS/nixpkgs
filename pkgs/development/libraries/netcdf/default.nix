{ stdenv
, fetchurl
, hdf5
, m4
, curl # for DAP
}:

let
  mpiSupport = hdf5.mpiSupport;
  mpi = hdf5.mpi;
in stdenv.mkDerivation rec {
  name = "netcdf-4.6.1";

  src = fetchurl {
    url = "https://www.unidata.ucar.edu/downloads/netcdf/ftp/${name}.tar.gz";
    sha256 = "0hi61cdihwwvz5jz1l7yq712j7ca1cj4bhr8x0x7c2vlb1s9biw9";
  };

  postPatch = ''
    patchShebangs .

    # this test requires the net
    for a in ncdap_test/Makefile.am ncdap_test/Makefile.in; do
      substituteInPlace $a --replace testurl.sh " "
    done
  '';

  nativeBuildInputs = [ m4 ];
  buildInputs = [ hdf5 curl mpi ];

  passthru = {
    mpiSupport = mpiSupport;
    inherit mpi;
  };

  configureFlags = [
      "--enable-netcdf-4"
      "--enable-dap"
      "--enable-shared"
  ]
  ++ (stdenv.lib.optionals mpiSupport [ "--enable-parallel-tests" "CC=${mpi}/bin/mpicc" ]);

  meta = {
      platforms = stdenv.lib.platforms.unix;
      homepage = https://www.unidata.ucar.edu/software/netcdf/;
  };
}
