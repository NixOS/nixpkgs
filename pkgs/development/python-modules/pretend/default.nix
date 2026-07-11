{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pretend";
  version = "1.0.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "alex";
    repo = "pretend";
    rev = "v${version}";
    hash = "sha256-OqMfeIMFNBBLq6ejR3uOCIHZ9aA4zew7iefVlAsy1JQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pretend" ];

  meta = {
    description = "Module for stubbing";
    homepage = "https://github.com/alex/pretend";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
