{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  pyyaml,
  typing-extensions,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "confuse";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "confuse";
    rev = "v${version}";
    hash = "sha256-QUCW/h/aqcS4yrkPSStSt5txhe6Ihco5USFlY1/QQVo=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    pyyaml
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "confuse" ];

  meta = {
    description = "Python configuration library for Python that uses YAML";
    homepage = "https://github.com/beetbox/confuse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lovesegfault
      doronbehar
    ];
  };
}
