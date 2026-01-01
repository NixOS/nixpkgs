{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-loki";
<<<<<<< HEAD
  version = "0.13.0";
=======
  version = "0.12.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "pySigma-backend-loki";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-36fdFuvUSAeGyV5z55/MGcdMiCNz12EbiRw87MjmaKY=";
=======
    hash = "sha256-2VgrIJocFtMFZCTyPQZcSnNJ5XgfD+nbmJ1wvesrQoE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  pythonRelaxDeps = [ "pysigma" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sigma.backends.loki" ];

  disabledTestPaths = [
    # Tests are out-dated
    "tests/test_backend_loki_field_modifiers.py"
  ];

<<<<<<< HEAD
  meta = {
    description = "Library to support the loki backend for pySigma";
    homepage = "https://github.com/grafana/pySigma-backend-loki";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Library to support the loki backend for pySigma";
    homepage = "https://github.com/grafana/pySigma-backend-loki";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ peterromfeldhk ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
