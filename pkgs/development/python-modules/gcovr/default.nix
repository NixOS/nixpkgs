{ stdenv
, buildPythonPackage
, fetchPypi
, jinja2
, lxml
}:

buildPythonPackage rec {
  pname = "gcovr";
  version = "4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gyady7x3v3l9fm1zan0idaggqqcm31y7g5vxk7h05p5h7f39bjs";
  };

  propagatedBuildInputs = [
    jinja2
    lxml
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

  meta = with stdenv.lib; {
    description = "A Python script for summarizing gcov data";
    license = licenses.bsd0;
    homepage = https://www.gcovr.com/;
  };

}
