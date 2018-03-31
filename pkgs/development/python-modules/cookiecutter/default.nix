{ stdenv, buildPythonPackage, fetchPypi, isPyPy
, itsdangerous, pytest, freezegun, docutils, jinja2, future, binaryornot, click
, whichcraft, poyo, jinja2_time }:

buildPythonPackage rec {
  pname = "cookiecutter";
  version = "1.4.0";

  # not sure why this is broken
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1clxnabmc5s4b519r1sxyj1163x833ir8xcypmdfpf6r9kbb35vn";
  };

  buildInputs = [ itsdangerous pytest freezegun docutils ];
  propagatedBuildInputs = [
    jinja2 future binaryornot click whichcraft poyo jinja2_time
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/audreyr/cookiecutter;
    description = "A command-line utility that creates projects from project templates";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kragniz ];
  };
}
