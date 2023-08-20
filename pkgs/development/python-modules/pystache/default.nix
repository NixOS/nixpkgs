{ lib, buildPythonPackage, unittestCheckHook, fetchPypi, isPy3k, glibcLocales }:

buildPythonPackage rec {
  pname = "pystache";
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4CkCIzBJsW4L4alPDHOJ6AViX2c1eD9FM7AgtaOKJ8c=";
  };

  LC_ALL = "en_US.UTF-8";

  buildInputs = [ glibcLocales ];

  # SyntaxError Python 3
  # https://github.com/defunkt/pystache/issues/181
  doCheck = !isPy3k;

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "A framework-agnostic, logic-free templating system inspired by ctemplate and et";
    homepage = "https://github.com/defunkt/pystache";
    license = licenses.mit;
  };
}
