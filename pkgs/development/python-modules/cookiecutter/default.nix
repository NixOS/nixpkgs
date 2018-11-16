{ stdenv, buildPythonPackage, fetchPypi, isPyPy
, pytest, pytestcov, pytest-mock, freezegun
, jinja2, future, binaryornot, click, whichcraft, poyo, jinja2_time, requests }:

buildPythonPackage rec {
  pname = "cookiecutter";
  version = "1.6.0";

  # not sure why this is broken
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1316a52e1c1f08db0c9efbf7d876dbc01463a74b155a0d83e722be88beda9a3e";
  };

  checkInputs = [ pytest pytestcov pytest-mock freezegun ];
  propagatedBuildInputs = [
    jinja2 future binaryornot click whichcraft poyo jinja2_time requests
  ];
  
  # requires network access for cloning git repos
  doCheck = false;
  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/audreyr/cookiecutter;
    description = "A command-line utility that creates projects from project templates";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kragniz ];
  };
}
