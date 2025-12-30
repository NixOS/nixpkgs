{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  pytestCheckHook,
  setuptools,
  pytest-cov-stub,
  attrs,
}:

buildPythonPackage rec {
  pname = "price-parser";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapinghub";
    repo = "price-parser";
    tag = version;
    hash = "sha256-9f/+Yw94SVvg9fl9zYR9YEMwAgKHwySG5cysPMomnA0=";
  };

  build-system = [ setuptools ];

  dependencies = [ attrs ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "price_parser" ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Extract price amount and currency symbol from a raw text string";
    homepage = "https://github.com/scrapinghub/price-parser";
    changelog = "https://github.com/scrapinghub/price-parser/blob/${version}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thanegill ];
  };
}
