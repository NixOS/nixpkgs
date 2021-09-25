{ lib
, buildPythonPackage
, fetchPypi
, jinja2
, lxml
, pygments
}:

buildPythonPackage rec {
  pname = "gcovr";
  version = "5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d80264cbaadff356b3dda71b8c62b3aa803e5b3eb6d526a24932cd6660a2576";
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
    description = "A Python script for summarizing gcov data";
    license = licenses.bsd0;
    homepage = "https://www.gcovr.com/";
  };
}
