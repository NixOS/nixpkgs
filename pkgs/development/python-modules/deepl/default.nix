{ lib
, buildPythonPackage
, fetchPypi
, requests
, poetry-core
, keyring
}:

buildPythonPackage rec {
  pname = "deepl";
  version = "1.15.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BRFC4R5d1gxHyEJI41Fi0Az8GqmDG7mQ6Fx/o23OGcE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    requests
    keyring
  ];

  # Requires internet access and an API key
  doCheck = false;

  pythonImportsCheck = [
    "deepl"
  ];

  meta = with lib; {
    description = "A language translation API that allows other computer programs to send texts and documents to DeepL's servers and receive high-quality translations";
    homepage = "https://github.com/DeepLcom/deepl-python";
    changelog = "https://github.com/DeepLcom/deepl-python/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ MaskedBelgian ];
  };
}
