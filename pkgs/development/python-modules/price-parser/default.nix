{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
  gitUpdater,
  pytestCheckHook,
  setuptools,
  pytest-cov-stub,
=======
  pytestCheckHook,
  setuptools,
  pytest-cov,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  attrs,
}:

buildPythonPackage rec {
  pname = "price-parser";
  version = "0.4.0";
<<<<<<< HEAD
  pyproject = true;
=======
  format = "setuptools";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "price-parser";
    tag = version;
    hash = "sha256-9f/+Yw94SVvg9fl9zYR9YEMwAgKHwySG5cysPMomnA0=";
  };

<<<<<<< HEAD
  build-system = [ setuptools ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  dependencies = [ attrs ];

  nativeCheckInputs = [
    pytestCheckHook
<<<<<<< HEAD
    pytest-cov-stub
=======
    pytest-cov
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "price_parser" ];

<<<<<<< HEAD
  passthru.updateScript = gitUpdater { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Extract price amount and currency symbol from a raw text string";
    homepage = "https://github.com/scrapinghub/price-parser";
    changelog = "https://github.com/scrapinghub/price-parser/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thanegill ];
  };
}
