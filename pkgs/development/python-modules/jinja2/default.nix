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
  version = "3.0.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "827a0e32839ab1600d4eb1c4c33ec5a8edfbc5cb42dafa13b81f182f97784b45";
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

  pytestFlagsArray = [
    # Avoid failure due to deprecation warning
    # Fixed in https://github.com/python/cpython/pull/28153
    # Remove after cpython 3.9.8
    "-p no:warnings"
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
