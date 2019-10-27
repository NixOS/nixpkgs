{ stdenv, menhir, easy-format, fetchFromGitHub, buildDunePackage, which, biniou, yojson }:

buildDunePackage rec {
  pname = "atd";
  version = "2.0.0";

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "mjambon";
    repo = pname;
    rev = version;
    sha256 = "0alzmk97rxg7s6irs9lvf89dy9n3r769my5n4j9p9qyigcdgjaia";
  };

  createFindlibDestdir = true;

  buildInputs = [ which menhir ];
  propagatedBuildInputs = [ easy-format biniou yojson ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mjambon/atd;
    description = "Syntax for cross-language type definitions";
    license = licenses.bsd3;
    maintainers = with maintainers; [ aij jwilberding ];
  };
}
