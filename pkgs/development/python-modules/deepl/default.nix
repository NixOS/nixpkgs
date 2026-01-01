{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  poetry-core,
  keyring,
}:

buildPythonPackage rec {
  pname = "deepl";
  version = "1.25.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nFvmNQVug6czSECorez9lixcuFV58hsVwQZD6dd8I4o=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    requests
    keyring
  ];

  # Requires internet access and an API key
  doCheck = false;

  pythonImportsCheck = [ "deepl" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Language translation API that allows other computer programs to send texts and documents to DeepL's servers and receive high-quality translations";
    mainProgram = "deepl";
    homepage = "https://github.com/DeepLcom/deepl-python";
    changelog = "https://github.com/DeepLcom/deepl-python/blob/v${version}/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MaskedBelgian ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ MaskedBelgian ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
