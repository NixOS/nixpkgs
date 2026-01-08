{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "recontrack";
  version = "0.1.0-unstable-2025-07-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "reconurge";
    repo = "recontrack";
    # https://github.com/reconurge/recontrack/issues/1
    rev = "07b3e027d3182d2b03a5b638652bbf7e3dd33714";
    hash = "sha256-MQGbMZc8YgJbVKRzbtz4nfaAztV8mk1k/2CA3ZU2yRM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "recontrack" ];

  meta = {
    description = "Module to sniff out tracking codes from websites by analyzing their HTML and embedded scripts";
    homepage = "https://github.com/reconurge/recontrack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
