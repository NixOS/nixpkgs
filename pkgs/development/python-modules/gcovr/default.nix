{ lib
, buildPythonPackage
, fetchPypi
, jinja2
, lxml
, pygments
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gcovr";
  version = "5.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IXGVCF7JQ0YpGoe3sebZz97u5WKz4PmjKyXJUws7zo8=";
  };

  propagatedBuildInputs = [
    jinja2
    lxml
    pygments
  ];

  # There are no unit tests in the pypi tarball. Most of the unit tests on the
  # github repository currently only work with gcc5, so we just disable them.
  # See also: https://github.com/gcovr/gcovr/issues/206
  doCheck = false;

  pythonImportsCheck = [
    "gcovr"
    "gcovr.workers"
    "gcovr.configuration"
  ];

  meta = with lib; {
    description = "Python script for summarizing gcov data";
    homepage = "https://www.gcovr.com/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };
}
