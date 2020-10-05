{ lib, fetchFromGitHub, meson, ninja, buildPythonPackage, pytest, pkgconfig, cairo, xlibsWrapper, isPy3k }:

buildPythonPackage rec {
  pname = "pycairo";
  version = "1.20.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pycairo";
    rev = "v${version}";
    sha256 = "0ifw4wjbml512w9kqj80y9gfqa7fkgfa1zkvi478k5krghjgk3lr";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    cairo
    xlibsWrapper
  ];

  checkInputs = [ pytest ];

  mesonFlags = [ "-Dpython=${if isPy3k then "python3" else "python"}" ];

  meta = with lib; {
    description = "Python 2/3 bindings for cairo";
    homepage = "https://pycairo.readthedocs.io/";
    license = with licenses; [ lgpl2 mpl11 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
