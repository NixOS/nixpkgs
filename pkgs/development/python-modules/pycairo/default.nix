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
  version = "1.25.1";

  disabled = pythonOlder "3.6";

  format = "other";

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pycairo";
    rev = "refs/tags/v${version}";
    hash = "sha256-HH4BjdSkdL8lI8L/Z2ltuuWWOkfetfgv4WQm6PIoEa0=";
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
    "-Dpython=${python.pythonOnBuildForHost.interpreter}"
  ];

  meta = with lib; {
    description = "Python 3 bindings for cairo";
    homepage = "https://pycairo.readthedocs.io/";
    license = with licenses; [ lgpl21Only mpl11 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
