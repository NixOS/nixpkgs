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
  version = "2025.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NetApp";
    repo = "recline";
    tag = "v${version}";
    sha256 = "sha256-xEH6fEq84nD3X6bPj1Yw36mjwHKlFKsVaMh4Iogzl18=";
  };

  build-system = [ setuptools ];

  dependencies = [ argcomplete ];

  nativeCheckInputs = [
    pudb
    pytestCheckHook
  ];

  pythonImportsCheck = [ "recline" ];

  meta = {
    description = "This library helps you quickly implement an interactive command-based application";
    homepage = "https://github.com/NetApp/recline";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
