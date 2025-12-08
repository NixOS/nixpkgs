{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pytz,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "datetime";
  version = "6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "datetime";
    tag = version;
    hash = "sha256-bxFdj9B0LUbnn/q5RcO3tBwqAMMl3Ovom036y0yfUbE=";
  };

  propagatedBuildInputs = [
    pytz
    zope-interface
  ];

  pythonImportsCheck = [ "DateTime" ];

  meta = with lib; {
    description = "DateTime data type, as known from Zope";
    homepage = "https://github.com/zopefoundation/DateTime";
    changelog = "https://github.com/zopefoundation/DateTime/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = with maintainers; [ icyrockcom ];
  };
}
