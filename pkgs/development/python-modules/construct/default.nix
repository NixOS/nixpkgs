{ lib
, stdenv
, arrow
, buildPythonPackage
, cloudpickle
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

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    arrow
    ruamel-yaml
    cloudpickle
  ];

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
