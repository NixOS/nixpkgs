{ lib
, aspectlib
, buildPythonPackage
, elasticsearch
, elastic-transport
, fetchFromGitHub
, fetchpatch
, freezegun
, git
, mercurial
, py-cpuinfo
, pygal
, pytest
, pytestCheckHook
, pytest-xdist
, pythonOlder
, isPy311
}:

buildPythonPackage rec {
  pname = "pytest-benchmark";
  version = "4.0.0";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f9Ty4+5PycraxoLUSa9JFusV5Cot6bBWKfOGHZIRR3o=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ionelmc/pytest-benchmark/commit/728752d2976ef53fde7e40beb3e55f09cf4d4736.patch";
      hash = "sha256-WIQADCLey5Y79UJUj9J5E02HQ0O86xBh/3IeGLpVrWI=";
    })
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    py-cpuinfo
  ];

  passthru.optional-dependencies = {
    aspect = [ aspectlib ];
    histogram = [ pygal ];
    elasticsearch = [ elasticsearch ];
  };

  pythonImportsCheck = [
    "pytest_benchmark"
  ];

  nativeCheckInputs = [
    elastic-transport
    freezegun
    git
    mercurial
    pytestCheckHook
    pytest-xdist
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  disabledTests = [
    # AttributeError: 'PluginImportFixer' object has no attribute 'find_spec'
    "test_compare_1"
    "test_compare_2"
    "test_regression_checks"
    "test_rendering"
  ]
  # tests are broken in 3.11
  # https://github.com/ionelmc/pytest-benchmark/issues/231
  ++ lib.optionals isPy311 [
    "test_abort_broken"
    "test_clonefunc"
  ];

  meta = with lib; {
    changelog = "https://github.com/ionelmc/pytest-benchmark/blob/${src.rev}/CHANGELOG.rst";
    description = "Pytest fixture for benchmarking code";
    homepage = "https://github.com/ionelmc/pytest-benchmark";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dotlambda ];
  };
}
