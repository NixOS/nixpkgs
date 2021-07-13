{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, Babel
, markupsafe
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Jinja2";
  version = "3.0.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "197ms1wimxql650245v63wkv04n8bicj549wfhp51bx68x5lhgvh";
  };

  propagatedBuildInputs = [
    Babel
    markupsafe
  ];

  # Multiple tests run out of stack space on 32bit systems with python2.
  # See https://github.com/pallets/jinja/issues/1158
  doCheck = !stdenv.is32bit;

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "http://jinja.pocoo.org/";
    description = "Stand-alone template engine";
    license = licenses.bsd3;
    longDescription = ''
      Jinja is a fast, expressive, extensible templating engine. Special
      placeholders in the template allow writing code similar to Python
      syntax. Then the template is passed data to render the final document.
      an optional sandboxed environment.
    '';
    maintainers = with maintainers; [ pierron sjourdois ];
  };
}
