{
  buildPythonPackage,
  fetchPypi,
  ply,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cppheaderparser";
  version = "2.7.4";
  pyproject = true;

  src = fetchPypi {
    pname = "CppHeaderParser";
    inherit version;
    hash = "sha256-OCswQW2VsKXoUCshSBDcrCpWQykX4mUUR9Or4lPjzEI=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ ply ];

  pythonImportsCheck = [ "CppHeaderParser" ];

  meta = {
    description = "Parse C++ header files using ply.lex to generate navigable class tree representing the class structure";
    homepage = "https://sourceforge.net/projects/cppheaderparser/";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ pamplemousse ];
  };
}
