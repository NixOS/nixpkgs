{ stdenv, lib, fetchFromGitHub, chez, chez-srfi }:

stdenv.mkDerivation rec {
  pname = "chez-mit";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "fedeinthemix";
    repo = "chez-mit";
    rev = "v${version}";
    sha256 = "sha256-YM4/Sj8otuWJCrUBsglVnihxRGI32F6tSbODFM0a8TA=";
  };

  buildInputs = [ chez chez-srfi ];

  makeFlags = [ "CHEZ=${lib.getExe chez}" ];

  doCheck = false;

  meta = with lib; {
    description = "This is a MIT/GNU Scheme compatibility library for Chez Scheme";
    homepage = "https://github.com/fedeinthemix/chez-mit/";
    maintainers = [ maintainers.jitwit ];
    license = licenses.gpl3Plus;
    broken = true;
  };

}
