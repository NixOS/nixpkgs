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
  version = "5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d4CEQ1m/8LlsBBR9r/8l5uWF4FWFvVQjabvDd9ad4SE=";
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
