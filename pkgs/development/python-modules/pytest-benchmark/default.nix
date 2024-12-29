{
  lib,
  aspectlib,
  buildPythonPackage,
  elasticsearch,
  elastic-transport,
  fetchFromGitHub,
  fetchpatch,
  freezegun,
  git,
  mercurial,
  py-cpuinfo,
  pygal,
  pytest,
  pytestCheckHook,
  pytest-xdist,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-benchmark";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ionelmc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f9Ty4+5PycraxoLUSa9JFusV5Cot6bBWKfOGHZIRR3o=";
  };

  patches = [
    # replace distutils.spawn.find_executable with shutil.which
    (fetchpatch {
      url = "https://github.com/ionelmc/pytest-benchmark/commit/728752d2976ef53fde7e40beb3e55f09cf4d4736.patch";
      hash = "sha256-WIQADCLey5Y79UJUj9J5E02HQ0O86xBh/3IeGLpVrWI=";
    })
    # fix tests with python3.11+; https://github.com/ionelmc/pytest-benchmark/pull/232
    (fetchpatch {
      url = "https://github.com/ionelmc/pytest-benchmark/commit/b2f624afd68a3090f20187a46284904dd4baa4f6.patch";
      hash = "sha256-cylxPj/d0YzvOGw+ncVSCnQHwq2cukrgXhBHePPwjO0=";
    })
    (fetchpatch {
      url = "https://github.com/ionelmc/pytest-benchmark/commit/2b987f5be1873617f02f24cb6d76196f9aed21bd.patch";
      hash = "sha256-92kWEd935Co6uc/1y5OGKsc5/or81bORSdaiQFjDyTw=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ py-cpuinfo ];

  passthru.optional-dependencies = {
    aspect = [ aspectlib ];
    histogram = [ pygal ];
    elasticsearch = [ elasticsearch ];
  };

  pythonImportsCheck = [ "pytest_benchmark" ];

  nativeCheckInputs = [
    elastic-transport
    freezegun
    git
    mercurial
    pytestCheckHook
    pytest-xdist
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  disabledTests = lib.optionals (pythonOlder "3.12") [
    # AttributeError: 'PluginImportFixer' object has no attribute 'find_spec'
    "test_compare_1"
    "test_compare_2"
    "test_regression_checks"
    "test_regression_checks_inf"
    "test_rendering"
  ];

  meta = with lib; {
    changelog = "https://github.com/ionelmc/pytest-benchmark/blob/${src.rev}/CHANGELOG.rst";
    description = "Pytest fixture for benchmarking code";
    homepage = "https://github.com/ionelmc/pytest-benchmark";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dotlambda ];
  };
}
