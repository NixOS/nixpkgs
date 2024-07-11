{
  lib,
  buildPythonPackage,
  fetchPypi,
  hypothesis,
  rfc3987,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rfc3986-validator";
  version = "0.1.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "rfc3986_validator";
    inherit version;
    hash = "sha256-PUS955IbO57Drk463KNwQ47M68Z2RWRJsUXVM7JA0FU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    rfc3987
  ];

  meta = with lib; {
    description = "Pure python rfc3986 validator";
    homepage = "https://github.com/naimetti/rfc3986-validator";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
