{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch, pytestCheckHook }:

buildPythonPackage rec {
  pname = "oscpy";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kivy";
    repo = "oscpy";
    rev = "v${version}";
    hash = "sha256-Luj36JLgU9xbBMydeobyf98U5zs5VwWQOPGV7TPXQwA=";
  };

  patches = [
    # Fix flaky tests with kivy/oscpy#67 - https://github.com/kivy/oscpy/pull/67
    (fetchpatch {
      name = "improve-reliability-of-test_intercept_errors.patch";
      url = "https://github.com/kivy/oscpy/commit/2bc114a97692aef28f8b84d52d0d5a41554a7d93.patch";
      hash = "sha256-iT7cB3ChWD1o0Zx7//Czkk8TaU1oTU1pRQWvPeIpeWY=";
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oscpy" ];

  meta = with lib; {
    description = "A modern implementation of OSC for python2/3";
    license = licenses.mit;
    homepage = "https://github.com/kivy/oscpy";
    maintainers = [ maintainers.yurkobb ];
  };
}
