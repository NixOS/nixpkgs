{ stdenv, buildPythonPackage, fetchPypi, pytest, pytestcov, mock, pytestpep8
, pytest_xdist, covCore, glibcLocales }:

buildPythonPackage rec {
  pname = "dyn";
  version = "1.6.3";
  name  = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xq90fliix5nbv934s3wf2pahmx6m2b9y0kqwn192c76qh7xlzib";
  };

  buildInputs = [ glibcLocales ];

  checkInputs = [
    pytest
    pytestcov
    mock
    pytestpep8
    pytest_xdist
    covCore
  ];
  # Disable checks because they are not stateless and require internet access.
  doCheck = false;

  LC_ALL="en_US.UTF-8";

  meta = with stdenv.lib; {
    description = "Dynect dns lib";
    homepage = "http://dyn.readthedocs.org/en/latest/intro.html";
    license = licenses.bsd3;
  };
}
