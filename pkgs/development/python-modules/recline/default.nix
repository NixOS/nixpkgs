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
  version = "2023.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "NetApp";
    repo = "recline";
    rev = "v${version}";
    sha256 = "sha256-jsWOPkzhN4D+Q/lK5yWg1kTgFkmOEIQY8O7oAXq5Nak=";
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
    maintainers = with maintainers; [ ];
  };
}
