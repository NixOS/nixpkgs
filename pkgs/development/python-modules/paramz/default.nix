{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  setuptools,
  numpy,
  scipy,
  six,
  decorator,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "paramz";
  version = "0.9.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0917211c0f083f344e7f1bc997e0d713dbc147b6380bc19f606119394f820b9a";
  };

  patches = [
    (fetchpatch {
      name = "remove-deprecated-numpy-uses";
      url = "https://github.com/sods/paramz/pull/38/commits/a5a0be15b12c5864b438d870b519ad17cc72cd12.patch";
      hash = "sha256-vj/amEXL9QJ7VdqJmyhv/lj8n+yuiZEARQBYWw6lgBA=";
    })
    (fetchpatch {
      name = "_raveled_index_for.patch";
      url = "https://github.com/sods/paramz/pull/40/commits/dd68a81cfd28edb48354c6a9b493ef711f00fb5b.patch";
      hash = "sha256-nbnW3lYJDT1WXko3Y28YyELhO0QIAA1Tx0CJ57T1Nq0=";
    })
  ];

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    scipy
    six
    decorator
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    substituteInPlace paramz/tests/parameterized_tests.py \
      --replace-fail "assertRaisesRegexp" "assertRaisesRegex"
  '';

  pytestFlagsArray = [
    "paramz/tests/array_core_tests.py"
    "paramz/tests/cacher_tests.py"
    "paramz/tests/examples_tests.py"
    "paramz/tests/index_operations_tests.py"
    "paramz/tests/init_tests.py"
    "paramz/tests/lists_and_dicts_tests.py"
    "paramz/tests/model_tests.py"
    "paramz/tests/observable_tests.py"
    "paramz/tests/parameterized_tests.py"
    "paramz/tests/pickle_tests.py"
    "paramz/tests/verbose_optimize_tests.py"
  ];

  pythonImportsCheck = [ "paramz" ];

  meta = with lib; {
    description = "Parameterization framework for parameterized model creation and handling";
    homepage = "https://github.com/sods/paramz";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
