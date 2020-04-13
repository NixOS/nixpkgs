{ stdenv, buildDunePackage, fetchFromGitHub, ocamlnet, cpu }:

buildDunePackage rec {
  pname = "parany";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "19yz1yqyqx6gawy93jlh3x6vji2p9qsy6nsbj65q5pii8p1fjlsm";
  };

  propagatedBuildInputs = [ ocamlnet cpu ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Generalized map/reduce for multicore computing";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
