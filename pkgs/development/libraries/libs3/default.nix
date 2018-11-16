{ stdenv, fetchFromGitHub, curl, libxml2 }:

stdenv.mkDerivation {
  name = "libs3-2017-06-01";

  src = fetchFromGitHub {
    owner = "bji";
    repo = "libs3";
    rev = "fd8b149044e429ad30dc4c918f0713cdd40aadd2";
    sha256 = "0a4c9rsd3wildssvnvph6cd11adn0p3rd4l02z03lvxkjhm20gw3";
  };

  buildInputs = [ curl libxml2 ];

  # added to fix build with gcc7, review on update
  NIX_CFLAGS_COMPILE = [ "-Wno-error=format-truncation" ];

  DESTDIR = "\${out}";

  meta = with stdenv.lib; {
    homepage = https://github.com/bji/libs3;
    description = "A library for interfacing with amazon s3";
    license = licenses.lgpl3;
    platforms = platforms.linux;
  };
}
