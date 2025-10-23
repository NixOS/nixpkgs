{
  lib,
  argcomplete,
  buildPythonPackage,
  fetchFromGitHub,
  pudb,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "recline";
  version = "2025.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NetApp";
    repo = "recline";
    tag = "v${version}";
    sha256 = "sha256-WBMt5jDPCBmTgVdYDN662uU2HVjB1U3GYJwn0P56WsI=";
  };

  build-system = [ setuptools ];

  dependencies = [ argcomplete ];

  nativeCheckInputs = [
    pudb
    pytestCheckHook
  ];

  pythonImportsCheck = [ "recline" ];

  meta = with lib; {
    description = "This library helps you quickly implement an interactive command-based application";
    homepage = "https://github.com/NetApp/recline";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
