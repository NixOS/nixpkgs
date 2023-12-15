{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "addict";
  version = "2.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3b2210e0e067a281f5646c8c5db92e99b7231ea8b0eb5f74dbdf9e259d4e494";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "addict" ];

  meta = with lib; {
    description = "Module that exposes a dictionary subclass that allows items to be set like attributes";
    homepage = "https://github.com/mewwts/addict";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
