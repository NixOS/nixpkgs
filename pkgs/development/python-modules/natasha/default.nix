{ lib
, buildPythonPackage
, fetchPypi
, pymorphy2
, razdel
, navec
, slovnet
, yagry
, ipymarkup
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "natasha";
  version = "1.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rgguazgq06a8B9jeRnfHD5VTR+Xrd+8OCsQUfaGLEq0=";
  };

  propagatedBuildInputs = [ pymorphy2 navec razdel slovnet yagry ipymarkup ];

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tests/" ];
  pythonImportCheck = [ "natasha" ];

  meta = with lib; {
    description = "NLP framework for Russian language";
    homepage = "https://github.com/natasha/natasha";
    license = licenses.mit;
    maintainers = with maintainers; [ npatsakula ];
  };
}
