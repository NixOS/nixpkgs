{ stdenv, buildPythonPackage, fetchPypi
, pytest, markupsafe }:

buildPythonPackage rec {
  pname = "Jinja2";
  version = "2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ markupsafe ];

  checkPhase = ''
    pytest -v tests
  '';

  # RecursionError: maximum recursion depth exceeded
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://jinja.pocoo.org/;
    description = "Stand-alone template engine";
    license = licenses.bsd3;
    longDescription = ''
      Jinja2 is a template engine written in pure Python. It provides a
      Django inspired non-XML syntax but supports inline expressions and
      an optional sandboxed environment.
    '';
    maintainers = with maintainers; [ pierron garbas sjourdois ];
  };
}
