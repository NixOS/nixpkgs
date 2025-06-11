{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pybrowsers";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "roniemartinez";
    repo = "browsers";
    tag = version;
    hash = "sha256-GW5yuBc9lwGIUK/ZH4qHFXlA+wyMD6HdShq0A/ydb+k=";
  };

  build-system = [ poetry-core ];

  # Tests want to interact with actual browsers
  doCheck = false;

  pythonImportsCheck = [ "browsers" ];

  meta = {
    description = "Python library for detecting and launching browsers";
    homepage = "https://github.com/roniemartinez/browsers";
    changelog = "https://github.com/roniemartinez/browsers/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
