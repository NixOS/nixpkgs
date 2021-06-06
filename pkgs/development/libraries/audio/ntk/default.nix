{ lib, stdenv, fetchFromGitHub, cairo, libjpeg, libXft, pkg-config, python2, wafHook }:

stdenv.mkDerivation rec {
  pname = "ntk";
  version = "1.3.1000";
  src = fetchFromGitHub {
    owner = "original-male";
    repo = "ntk";
    rev = "v${version}";
    sha256 = "0j38mhnfqy6swcrnc5zxcwlqi8b1pgklyghxk6qs1lf4japv2zc0";
  };

  nativeBuildInputs = [ pkg-config wafHook ];
  buildInputs = [
    cairo libjpeg libXft python2
  ];

  meta = {
    description = "Fork of FLTK 1.3.0 with additional functionality";
    version = version;
    homepage = "http://non.tuxfamily.org/";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ magnetophon nico202 ];
    platforms = lib.platforms.linux;
  };
}
