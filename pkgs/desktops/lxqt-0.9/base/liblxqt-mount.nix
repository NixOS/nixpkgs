{ stdenv, fetchFromGitHub
, cmake
, qt54
, liblxqt
}:

stdenv.mkDerivation rec {
  basename = "liblxqt-mount";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = basename;
    rev = version;
    sha256 = "1njfbg5ia7417dqn0bb11998ivdp2dg14ym7hihi5v2wvm48n161";
  };

  buildInputs = [ stdenv cmake qt54.base qt54.tools liblxqt ];

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Library used to manage removable devices";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
