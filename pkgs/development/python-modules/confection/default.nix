{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  srsly,
}:

buildPythonPackage rec {
  pname = "confection";
  version = "0.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1XIo9Hg4whYS1AkFeX8nVnpv+IvnpmyydHYdVYS0xZc=";
  };

  propagatedBuildInputs = [
    pydantic
    srsly
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "confection" ];

  meta = with lib; {
    description = "Library that offers a configuration system";
    homepage = "https://github.com/explosion/confection";
    changelog = "https://github.com/explosion/confection/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
