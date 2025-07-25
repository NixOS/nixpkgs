{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  twisted,
}:

buildPythonPackage rec {
  pname = "nevow";
  version = "0.14.5";
  format = "setuptools";
  disabled = isPy3k;

  src = fetchPypi {
    pname = "Nevow";
    inherit version;
    sha256 = "afb6ba85a5351953578c018fcdb9dfbd62f29a8d46c58bc9652bc000a27223f3";
  };

  propagatedBuildInputs = [ twisted ];

  nativeCheckInputs = [ twisted ];

  checkPhase = ''
    trial formless nevow
  '';

  meta = with lib; {
    description = "Nevow, a web application construction kit for Python";
    longDescription = ''
      Nevow - Pronounced as the French "nouveau", or "noo-voh", Nevow
      is a web application construction kit written in Python.  It is
      designed to allow the programmer to express as much of the view
      logic as desired in Python, and includes a pure Python XML
      expression syntax named stan to facilitate this.  However it
      also provides rich support for designer-edited templates, using
      a very small XML attribute language to provide bi-directional
      template manipulation capability.

      Nevow also includes formless, a declarative syntax for
      specifying the types of method parameters and exposing these
      methods to the web.  Forms can be rendered automatically, and
      form posts will be validated and input coerced, rendering error
      pages if appropriate.  Once a form post has validated
      successfully, the method will be called with the coerced values.
    '';
    homepage = "https://github.com/twisted/nevow";
    license = licenses.mit;
  };
}
