{
  buildPythonPackage,
  copier,
  corallium,
  fetchFromGitHub,
  lib,
  poetry-core,
  poetry-dynamic-versioning,
}:
buildPythonPackage rec {
  pname = "copier-template-tester";
  version = "2.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "KyleKing";
    repo = pname;
    tag = version;
    hash = "sha256-n/39Gl4q24QKfVFaeeqqu0AQt2jRSRrcnEOFRHQ+SQE=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    copier
    corallium
  ];

  meta = with lib; {
    description = "CLI and pre-commit tool for testing copier";
    homepage = "https://copier-template-tester.kyleking.me";
    license = licenses.mit;
    maintainers = with maintainers; [ yajo ];
  };
}
