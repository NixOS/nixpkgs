{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, bleak
, pyyaml
, voluptuous
, pytestCheckHook
, pytest-asyncio
, poetry-core
}:

buildPythonPackage rec {
  pname = "idasen";
  version = "0.8.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "newAM";
    repo = "idasen";
    rev = "v${version}";
    sha256 = "09s1409ln1x6sxsls2ndqz3piapbwf880rrhmydfm6y7hqxlmzvy";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    bleak
    pyyaml
    voluptuous
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "idasen" ];

  meta = with lib; {
    description = "Python API and CLI for the ikea IDÅSEN desk";
    homepage = "https://github.com/newAM/idasen";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
