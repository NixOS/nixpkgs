{ stdenv, buildPythonPackage, fetchPypi
, pytest, markupsafe }:

buildPythonPackage rec {
  pname = "Jinja2";
  version = "2.10.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9fe95f19286cfefaa917656583d020be14e7859c6b0252588391e47db34527de";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ markupsafe ];

  checkPhase = ''
    pytest -v tests
  '';

  meta = with stdenv.lib; {
    homepage = http://jinja.pocoo.org/;
    description = "Stand-alone template engine";
    license = licenses.bsd3;
    longDescription = ''
      Jinja2 is a template engine written in pure Python. It provides a
      Django inspired non-XML syntax but supports inline expressions and
      an optional sandboxed environment.
    '';
    maintainers = with maintainers; [ pierron sjourdois ];
  };
}
