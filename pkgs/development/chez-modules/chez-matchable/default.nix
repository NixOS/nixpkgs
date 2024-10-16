{ stdenv, lib, fetchFromGitHub, chez }:

stdenv.mkDerivation rec {
  pname = "chez-matchable";
  version = "20160306";

  src = fetchFromGitHub {
    owner = "fedeinthemix";
    repo = "chez-matchable";
    rev = "v${version}";
    sha256 = "sha256-Opw8m/4eKBt9Q5nb+y9/1XwUj/QTclp6+ENcREY/Fgs=";
  };

  buildInputs = [ chez ];

  makeFlags = [ "CHEZ=${lib.getExe chez}" "PREFIX=$(out)" ];

  doCheck = false;

  meta = with lib; {
    description = "This is a Library for ChezScheme providing the portable hygenic pattern matcher by Alex Shinn";
    homepage = "https://github.com/fedeinthemix/chez-matchable/";
    maintainers = [ maintainers.jitwit ];
    license = licenses.publicDomain;
  };

}
