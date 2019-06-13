{ stdenv
, buildPythonPackage
, fetchPypi
, jinja2
}:

buildPythonPackage rec {
  pname = "gcovr";
  version = "4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca94c337f2d9a70db177ec4330534fad7b2b772beda625c1ec071fbcf1361e22";
  };

  propagatedBuildInputs = [
    jinja2
  ];

  # There are no unit tests in the pypi tarball. Most of the unit tests on the
  # github repository currently only work with gcc5, so we just disable them.
  # See also: https://github.com/gcovr/gcovr/issues/206
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Python script for summarizing gcov data";
    license = licenses.bsd0;
    homepage = https://www.gcovr.com/;
  };

}
