{ lib
, buildPythonPackage
, fetchPypi
, requests
, poetry-core
, keyring
}:

buildPythonPackage rec {
  pname = "deepl";
  version = "1.13.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rq7L/rgfJJ3ZspuL1IfZv+x60t8cZRPkrVryJf12WLk=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ MaskedBelgian ];
  };
}
