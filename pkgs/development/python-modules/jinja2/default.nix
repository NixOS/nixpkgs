{ stdenv, buildPythonPackage, fetchPypi
, pytest, markupsafe }:

buildPythonPackage rec {
  pname = "Jinja2";
  version = "2.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "065c4f02ebe7f7cf559e49ee5a95fb800a9e4528727aec6f24402a5374c65013";
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
