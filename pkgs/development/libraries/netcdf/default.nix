{ lib, stdenv
, fetchurl, unzip
, hdf5
, m4
, curl # for DAP
, removeReferencesTo
}:

let
  inherit (hdf5) mpiSupport mpi;
in stdenv.mkDerivation rec {
  pname = "netcdf" + lib.optionalString mpiSupport "-mpi";
  version = "4.8.1";

  src = fetchurl {
    url = "https://downloads.unidata.ucar.edu/netcdf-c/${version}/netcdf-c-${version}.tar.gz";
    sha256 = "1cbjwjmp9691clacw5v88hmpz46ngxs3bfpkf2xy1j7cvlkc72l0";
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

  doCheck = !(mpiSupport || (stdenv.isDarwin && stdenv.isAarch64));
  checkInputs = [ unzip ];

  meta = {
      description = "Libraries for the Unidata network Common Data Format";
      platforms = lib.platforms.unix;
      homepage = "https://www.unidata.ucar.edu/software/netcdf/";
      license = {
        url = "https://www.unidata.ucar.edu/software/netcdf/docs/copyright.html";
      };
  };
}
