{ lib, pythonOlder, fetchFromGitHub, meson, ninja, buildPythonPackage
, pytestCheckHook, pkg-config, cairo, python }:

buildPythonPackage rec {
  pname = "pycairo";
  version = "1.20.1";

  disabled = pythonOlder "3.6";

  format = "other";

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pycairo";
    rev = "v${version}";
    sha256 = "09aisph7ycgb4xi2xglvrn59i3cyqms8jbb876cl9763g7yqbcr6";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ cairo ];

  checkInputs = [ pytestCheckHook ];

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
