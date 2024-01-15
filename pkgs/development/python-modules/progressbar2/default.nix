{ lib
, buildPythonPackage
, fetchPypi
, freezegun
, pytestCheckHook
, python-utils
, pythonOlder
}:

buildPythonPackage rec {
  pname = "progressbar2";
  version = "4.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E5OSL8tkWYlErUV1afvrSzrBie9Qta25zvMoTofjlM4=";
  };

  postPatch = ''
    sed -i "/-cov/d" pytest.ini
  '';

  propagatedBuildInputs = [
    python-utils
  ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "progressbar"
  ];

  meta = with lib; {
    description = "Text progressbar library";
    homepage = "https://progressbar-2.readthedocs.io/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
}
