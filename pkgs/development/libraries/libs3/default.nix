{ stdenv, fetchFromGitHub, curl, libxml2 }:

stdenv.mkDerivation {
  name = "libs3-2015-01-09";

  src = fetchFromGitHub {
    owner = "bji";
    repo = "libs3";
    rev = "4d21fdc0857b88c964649b321057d7105d1e4da3";
    sha256 = "1c33h8lzlpmsbkymd2dac9g8hqhd6j6yzdjrhha8bcqyys6vcpy3";
  };

  buildInputs = [ curl libxml2 ];

  DESTDIR = "\${out}";

  meta = with stdenv.lib; {
    homepage = https://github.com/bji/libs3;
    description = "A library for interfacing with amazon s3";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
