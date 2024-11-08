{ stdenv, lib, fetchFromGitHub, chez }:

stdenv.mkDerivation rec {
  pname = "chez-matchable";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "fedeinthemix";
    repo = "chez-matchable";
    rev = "v${version}";
    sha256 = "sha256-UYoT8Kp1FTfiL22ntrFXFcAB1HGVrJ6p9JgvhUKi+Yo=";
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
