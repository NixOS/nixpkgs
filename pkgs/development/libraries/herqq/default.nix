{ stdenv, qt5, unzip, fetchFromGitHub, qtmultimedia }:

stdenv.mkDerivation rec {
  version = "2.1.0";
  pname = "herqq";

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
    broken = true; # 2018-09-21, built with qt510 (which was removed) but neither qt59 nor qt511
  };
}
