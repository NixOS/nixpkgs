{ lib, fetchFromGitHub, meson, ninja, buildPythonPackage, pytest, pkgconfig, cairo, xlibsWrapper, isPy33, isPy3k }:

buildPythonPackage rec {
  pname = "pycairo";
  version = "1.18.1";

  format = "other";

  disabled = isPy33;

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pycairo";
    rev = "v${version}";
    sha256 = "0f4l7d1ibkk8xdspyv5zx8fah9z3x775bd91zirnp37vlgqds7xj";
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
    homepage = https://pycairo.readthedocs.io/;
    license = with licenses; [ lgpl2 mpl11 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
