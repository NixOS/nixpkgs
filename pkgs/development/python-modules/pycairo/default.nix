{ lib
, pythonOlder
, fetchFromGitHub
, meson
, ninja
, buildPythonPackage
, pytestCheckHook
, pkg-config
, cairo
, libxcrypt
, python
}:

buildPythonPackage rec {
  pname = "pycairo";
  version = "1.23.0";

  disabled = pythonOlder "3.6";

  format = "other";

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pycairo";
    rev = "refs/tags/v${version}";
    hash = "sha256-tkyVTJUdL2pBpBUpWsiDPKnd5OV88w3TdEOMxMc+hPM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    cairo
  ] ++ lib.optionals (pythonOlder "3.9") [
    libxcrypt
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  mesonFlags = [
    # This is only used for figuring out what version of Python is in
    # use, and related stuff like figuring out what the install prefix
    # should be, but it does need to be able to execute Python code.
    "-Dpython=${python.pythonForBuild.interpreter}"
  ];

  meta = with lib; {
    description = "Python 3 bindings for cairo";
    homepage = "https://pycairo.readthedocs.io/";
    license = with licenses; [ lgpl21Only mpl11 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
