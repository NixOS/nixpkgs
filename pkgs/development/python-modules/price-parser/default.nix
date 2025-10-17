{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  pytest-cov,
  attrs,
}:

buildPythonPackage rec {
  pname = "price-parser";
  version = "0.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "price-parser";
    tag = version;
    hash = "sha256-9f/+Yw94SVvg9fl9zYR9YEMwAgKHwySG5cysPMomnA0=";
  };

  dependencies = [ attrs ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [ "price_parser" ];

  meta = {
    description = "Extract price amount and currency symbol from a raw text string";
    homepage = "https://github.com/scrapinghub/price-parser";
    changelog = "https://github.com/scrapinghub/price-parser/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thanegill ];
  };
}
