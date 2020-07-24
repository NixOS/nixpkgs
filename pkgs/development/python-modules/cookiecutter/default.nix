{ stdenv, buildPythonPackage, fetchPypi, isPyPy
, pytest, pytestcov, pytest-mock, freezegun
, jinja2, future, binaryornot, click, whichcraft, poyo, jinja2_time, requests
, python-slugify }:

buildPythonPackage rec {
  pname = "cookiecutter";
  version = "1.7.2";

  # not sure why this is broken
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "efb6b2d4780feda8908a873e38f0e61778c23f6a2ea58215723bcceb5b515dac";
  };

  checkInputs = [ pytest pytestcov pytest-mock freezegun ];
  propagatedBuildInputs = [
    jinja2 future binaryornot click whichcraft poyo jinja2_time requests python-slugify
  ];
  
  # requires network access for cloning git repos
  doCheck = false;
  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/audreyr/cookiecutter";
    description = "A command-line utility that creates projects from project templates";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kragniz ];
  };
}
