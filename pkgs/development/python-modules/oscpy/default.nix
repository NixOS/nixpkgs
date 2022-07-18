{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook }:

buildPythonPackage rec {
  pname = "oscpy";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kivy";
    repo = "oscpy";
    rev = "v${version}";
    hash = "sha256-Luj36JLgU9xbBMydeobyf98U5zs5VwWQOPGV7TPXQwA=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oscpy" ];

  meta = with lib; {
    description = "A modern implementation of OSC for python2/3";
    license = licenses.mit;
    homepage = "https://github.com/kivy/oscpy";
    maintainers = [ maintainers.yurkobb ];
  };
}
