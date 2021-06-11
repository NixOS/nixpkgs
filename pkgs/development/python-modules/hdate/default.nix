{ lib
, astral
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "hdate";
  version = "0.10.3";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "py-libhdate";
    repo = "py-libhdate";
    rev = "v${version}";
    sha256 = "sha256-6rOsG6qgq4woBhj25SNWvKshvFLBL/6MJiBZb+NPvdk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    astral
    pytz
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace "^2020.5" ">=2020.5"
  '';

  pytestFlagsArray = [
    "tests"
  ];

  pythonImportsCheck = [ "hdate" ];

  meta = with lib; {
    description = "Python module for Jewish/Hebrew date and Zmanim";
    homepage = "https://github.com/py-libhdate/py-libhdate";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
