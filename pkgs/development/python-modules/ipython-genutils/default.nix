{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, nose
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ipython-genutils";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "ipython_genutils";
    inherit version;
    hash = "sha256-6y4RbnXs751NIo/cZq9UJpr6JqtEYwQuM3hbiHxii6g=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  preCheck = ''
    substituteInPlace ipython_genutils/tests/test_path.py \
      --replace "setUp" "setup_method" \
      --replace "tearDown" "teardown_method"
  '';

  pythonImportsCheck = [
    "ipython_genutils"
  ];

  meta = {
    description = "Vestigial utilities from IPython";
    homepage = "https://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
