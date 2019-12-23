{ stdenv, buildDunePackage, fetchFromGitHub, ocamlnet, setcore }:

buildDunePackage rec {
  pname = "parany";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0kylhgi1d4gj68x40ifli7pnrxkdc6ks5mgfvlcsigqg8i8nvc7q";
  };

  propagatedBuildInputs = [ ocamlnet setcore ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Generalized map/reduce for multicore computing";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
