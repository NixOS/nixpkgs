{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytz
, zope_interface
}:

buildPythonPackage rec {
  pname = "datetime";
  version = "5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "datetime";
    rev = "refs/tags/${version}";
    hash = "sha256-5H7s2y/2zsQC3Azs1yakotO8ZVLCRV8yPahbX09C5L8=";
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
    changelog = "https://github.com/zopefoundation/DateTime/releases/tag/${version}";
    license = licenses.zpl21;
    maintainers = with maintainers; [ icyrockcom ];
  };
}

