{ lib
, stdenv
, arrow
, buildPythonPackage
, cloudpickle
, cryptography
, fetchFromGitHub
, lz4
, numpy
, pytest-benchmark
, pytestCheckHook
, pythonOlder
, ruamel-yaml
, setuptools
}:

buildPythonPackage rec {
  pname = "construct";
  version = "2.10.68";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "construct";
    repo = "construct";
    rev = "refs/tags/v${version}";
    hash = "sha256-bp/YyRFP0rrBHPyhiqnn6o1iC5l61oedShZ2phGeqaw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    # Not an explicit dependency, but it's imported by an entrypoint
    lz4
  ];

  passthru.optional-dependencies = {
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
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "construct"
  ];

  disabledTests = [
    "test_benchmarks"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_multiprocessing"
  ];

  meta = with lib; {
    description = "Powerful declarative parser (and builder) for binary data";
    homepage = "https://construct.readthedocs.org/";
    changelog = "https://github.com/construct/construct/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor ];
  };
}
