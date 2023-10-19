{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytz
, zope_interface
}:

buildPythonPackage rec {
  pname = "datetime";
  version = "5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "datetime";
    rev = "refs/tags/${version}";
    hash = "sha256-J96IjyPyJaUC5mECK3g/cgxBh1OoVfj62XocBatYgOw=";
  };

  propagatedBuildInputs = [
    pytz
    zope_interface
  ];

  pythonImportsCheck = [
    "DateTime"
  ];

  meta = with lib; {
    description = "DateTime data type, as known from Zope";
    homepage = "https://github.com/zopefoundation/DateTime";
    changelog = "https://github.com/zopefoundation/DateTime/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ icyrockcom ];
  };
}

