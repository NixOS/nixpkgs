{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  poetry-core,
  keyring,
}:

buildPythonPackage (finalAttrs: {
  pname = "deepl";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-SvzNGYMomWr9E4CMHYORSr62kCMN7DFW+NaLsG5PP+4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    requests
    keyring
  ];

  # Requires internet access and an API key
  doCheck = false;

  pythonImportsCheck = [ "deepl" ];

  meta = {
    description = "Language translation API that allows other computer programs to send texts and documents to DeepL's servers and receive high-quality translations";
    mainProgram = "deepl";
    homepage = "https://github.com/DeepLcom/deepl-python";
    changelog = "https://github.com/DeepLcom/deepl-python/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MaskedBelgian ];
  };
})
