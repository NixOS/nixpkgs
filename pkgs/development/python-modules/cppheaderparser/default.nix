{ buildPythonPackage
, fetchPypi
, ply
, lib
}:

buildPythonPackage rec {
  pname = "cppheaderparser";
  version = "2.7.4";

  src = fetchPypi {
    pname = "CppHeaderParser";
    inherit version;
    hash = "sha256-OCswQW2VsKXoUCshSBDcrCpWQykX4mUUR9Or4lPjzEI=";
  };

  propagatedBuildInputs = [ ply ];

  pythonImportsCheck = [ "CppHeaderParser" ];

  meta = with lib; {
    description = "Parse C++ header files using ply.lex to generate navigable class tree representing the class structure";
    homepage = "https://sourceforge.net/projects/cppheaderparser/";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
