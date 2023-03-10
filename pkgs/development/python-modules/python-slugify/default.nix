{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, text-unidecode
, unidecode
}:

buildPythonPackage rec {
  pname = "python-slugify";
  version = "6.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "un33k";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JGjUNBEMuICsaClQGDSGX4qFRjecVKzmpPNRUTvfwho=";
  };

  propagatedBuildInputs = [
    text-unidecode
    unidecode
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test.py"
  ];

  pythonImportsCheck = [
    "slugify"
  ];

  meta = with lib; {
    description = "Python Slugify application that handles Unicode";
    homepage = "https://github.com/un33k/python-slugify";
    license = licenses.mit;
    maintainers = with maintainers; [ vrthra ];
  };
}
