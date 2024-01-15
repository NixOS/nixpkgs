{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, setuptools
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  version = "3.3.0";
  pname = "opt-einsum";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "opt_einsum";
    inherit version;
    hash = "sha256-WfZHX3e7w33PfNdIUZwOxgci6R5jyhFOaIIcDFSkZUk=";
  };

  patches = [
    # https://github.com/dgasmith/opt_einsum/pull/208
    (fetchpatch {
      name = "python312-compatibility.patch";
      url = "https://github.com/dgasmith/opt_einsum/commit/0beacf96923bbb2dd1939a9c59398a38ce7a11b1.patch";
      hash = "sha256-dmmEzhy17huclo1wOubpBUDc2L7vqEU5b/6a5loM47A=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "opt_einsum"
  ];

  meta = with lib; {
    description = "Optimizing NumPy's einsum function with order optimization and GPU support";
    homepage = "https://github.com/dgasmith/opt_einsum";
    license = licenses.mit;
    maintainers = with maintainers; [ teh ];
  };
}
