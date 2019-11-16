{ stdenv, buildPythonPackage, python, fetchPypi, isPy3k, glibcLocales }:

buildPythonPackage rec {
  pname = "pystache";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7bbc265fb957b4d6c7c042b336563179444ab313fb93a719759111eabd3b85a";
  };

  LC_ALL = "en_US.UTF-8";

  buildInputs = [ glibcLocales ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  # SyntaxError Python 3
  # https://github.com/defunkt/pystache/issues/181
  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    description = "A framework-agnostic, logic-free templating system inspired by ctemplate and et";
    homepage = https://github.com/defunkt/pystache;
    license = licenses.mit;
  };
}