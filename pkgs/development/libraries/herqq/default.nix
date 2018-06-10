{ stdenv, qt5, unzip, fetchFromGitHub, qtmultimedia }:

stdenv.mkDerivation rec {
  version = "2.1.0";
  name = "herqq-${version}";

  nativeBuildInputs = [ qt5.qmake ];
  buildInputs = [ qt5.qtbase unzip qtmultimedia ];
  preConfigure = "cd herqq";

  src = fetchFromGitHub {
    owner = "ThomArmax";
    repo = "HUPnP";
    rev = version;
    sha256 = "1w674rbwbhpirq70gp9rk6p068j36rwn112fx3nz613wgw63x84m";
  };

  meta = with stdenv.lib; {
    homepage = http://herqq.org;
    description = "A software library for building UPnP devices and control points";
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
