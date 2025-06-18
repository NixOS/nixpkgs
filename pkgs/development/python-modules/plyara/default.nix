{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  ply,

  pytestCheckHook,
  pycodestyle,
  pydocstyle,
  pyflakes,
  coverage,
}:

buildPythonPackage rec {
  pname = "plyara";
  version = "2.2.8";
  pyproject = true;

  disabled = pythonOlder "3.10"; # https://github.com/plyara/plyara: "Plyara requires Python 3.10+"

  src = fetchFromGitHub {
    owner = "plyara";
    repo = "plyara";
    tag = "v${version}";
    hash = "sha256-WaQgqx003it+D0AGDxV6aSKO89F2iR9d8L4zvHyd0iQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    ply
  ];

  pythonImportsCheck = [
    "plyara"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pycodestyle
    pydocstyle
    pyflakes
    coverage
  ];

  disabledTests = [
    # touches network
    "test_third_party_repositories"
  ];

  meta = {
    description = "Parse YARA rules";
    homepage = "https://github.com/plyara/plyara";
    changelog = "https://github.com/plyara/plyara/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      _13621
      ivyfanchiang
    ];
  };
}
