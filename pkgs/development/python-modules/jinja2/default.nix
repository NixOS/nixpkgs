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
  version = "3.0.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7";
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
    homepage = "https://jinja.palletsprojects.com/";
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
