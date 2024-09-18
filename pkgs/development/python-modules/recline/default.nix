{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pudb,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "recline";
  version = "2024.7.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "NetApp";
    repo = "recline";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Qc4oofuhSZ2S5zuCY9Ce9ISldYI3MDUJXFc8VcXdLIU=";
  };

  nativeBuildInputs = [ setuptools ];

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
