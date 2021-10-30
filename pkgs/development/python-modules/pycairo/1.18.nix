{ lib
, fetchFromGitHub
, meson
, ninja
, buildPythonPackage
, pytestCheckHook
, pkg-config
, cairo
, python
}:

buildPythonPackage rec {
  pname = "pycairo";
  version = "1.18.2";

  format = "other";

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pycairo";
    rev = "v${version}";
    sha256 = "142145a2whvlk92jijrbf3i2bqrzmspwpysj0bfypw0krzi0aa6j";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    cairo
  ];

  checkInputs = [
    pytestCheckHook
  ];

  mesonFlags = [
    "-Dpython=${python.interpreter}"
  ];

  meta = with lib; {
    description = "Python 2 bindings for cairo";
    homepage = "https://pycairo.readthedocs.io/";
    license = with licenses; [ lgpl21Only mpl11 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
