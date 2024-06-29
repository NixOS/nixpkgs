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
  version = "2024.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "NetApp";
    repo = "recline";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-wVUM5vkavdLDtwRlbtVlVaBOXX+7tcB+SxYe1jZdq9I=";
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
