{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "frozendict";
  version = "2.3.4";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "15b4b18346259392b0d27598f240e9390fafbff882137a9c48a1e0104fb17f78";
  };

  pythonImportsCheck = [
    "frozendict"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    pushd test
  '';

  postCheck = ''
    popd
  '';

  meta = with lib; {
    homepage = "https://github.com/Marco-Sulla/python-frozendict";
    description = "A simple immutable dictionary";
    license = licenses.lgpl3Only;
  };
}
