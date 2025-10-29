{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  cgen,
  numpy,
  platformdirs,
  pytools,
  typing-extensions,
  boost,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "codepy";
  version = "2025.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "codepy";
    tag = "v${version}";
    hash = "sha256-PHIC3q9jQlRRoUoemVtyrl5hcZXMX28gRkI5Xpk9yBY=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cgen
    numpy
    platformdirs
    pytools
    typing-extensions
  ];

  pythonImportsCheck = [ "codepy" ];

  doCheck = false; # tests require boost setup for ad hoc module compilation

  meta = with lib; {
    homepage = "https://github.com/inducer/codepy";
    description = "Generate and execute native code at run time, from Python";
    license = licenses.mit;
    maintainers = with maintainers; [ atila ];
  };
}
