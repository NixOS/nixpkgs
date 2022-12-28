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

  buildPhase = ''
    make PREFIX=$out CHEZ=${chez}/bin/scheme
  '';

  installPhase = ''
    make install PREFIX=$out CHEZ=${chez}/bin/scheme
  '';

  doCheck = false;

  meta = with lib; {
    description = "This is a MIT/GNU Scheme compatibility library for Chez Scheme";
    homepage = "https://github.com/fedeinthemix/chez-mit/";
    maintainers = [ maintainers.jitwit ];
    license = licenses.free;
  };

}
