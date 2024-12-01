{
  lib,
  stdenv,
  arrow,
  buildPythonPackage,
  cloudpickle,
  cryptography,
  fetchFromGitHub,
  lz4,
  numpy,
  pytestCheckHook,
  pythonOlder,
  ruamel-yaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "construct";
  version = "2.10.70";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "construct";
    repo = "construct";
    rev = "refs/tags/v${version}";
    hash = "sha256-5otjjIyje0+z/Y/C2ivmu08PNm0oJcSSvZkQfGxHDuQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    # Not an explicit dependency, but it's imported by an entrypoint
    lz4
  ];

  optional-dependencies = {
    extras = [
      arrow
      cloudpickle
      cryptography
      numpy
      ruamel-yaml
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "construct" ];

  disabledTests = [
    "test_benchmarks"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_multiprocessing" ];

  meta = with lib; {
    description = "Powerful declarative parser (and builder) for binary data";
    homepage = "https://construct.readthedocs.org/";
    changelog = "https://github.com/construct/construct/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}
