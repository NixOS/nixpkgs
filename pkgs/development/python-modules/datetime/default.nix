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
  version = "5.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "datetime";
    rev = "refs/tags/${version}";
    hash = "sha256-k4q9n3uikz+B9CUyqQTgl61OTKDWMsyhAt2gB1HWGRw=";
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
