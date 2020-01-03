{ stdenv, buildPythonPackage, fetchPypi, isPyPy
, pytest, pytestcov, pytest-mock, freezegun
, jinja2, future, binaryornot, click, whichcraft, poyo, jinja2_time, requests }:

buildPythonPackage rec {
  pname = "cookiecutter";
  version = "1.7.0";

  # not sure why this is broken
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bh4vf45q9nanmgwnw7m0gxirndih9yyz5s0y2xbnlbcqbhrg6a7";
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
