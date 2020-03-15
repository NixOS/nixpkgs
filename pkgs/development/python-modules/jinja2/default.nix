{ stdenv
, buildPythonPackage
, isPy3k
, fetchPypi
, pytest
, markupsafe }:

buildPythonPackage rec {
  pname = "Jinja2";
  version = "2.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "93187ffbc7808079673ef52771baa950426fd664d3aad1d0fa3e95644360e250";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ markupsafe ];

  # Multiple tests run out of stack space on 32bit systems with python2.
  # See https://github.com/pallets/jinja/issues/1158
  doCheck = !stdenv.is32bit || isPy3k;

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
