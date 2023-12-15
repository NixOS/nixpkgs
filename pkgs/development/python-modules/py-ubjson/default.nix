{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "py-ubjson";
  version = "0.16.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Iotic-Labs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1frn97xfa88zrfmpnvdk1pc03yihlchhph99bhjayvzlfcrhm5v3";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "test/test.py" ];

  pythonImportsCheck = [ "ubjson" ];

  meta = with lib; {
    description = "Universal Binary JSON draft-12 serializer for Python";
    homepage = "https://github.com/Iotic-Labs/py-ubjson";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
