{ buildPythonPackage
, fetchPypi
, ply
, stdenv
}:

buildPythonPackage rec {
  pname = "CppHeaderParser";
  version = "2.7.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OCswQW2VsKXoUCshSBDcrCpWQykX4mUUR9Or4lPjzEI=";
  };

  propagatedBuildInputs = [ ply ];

  pythonImportsCheck = [ "CppHeaderParser" ];

  meta = with stdenv.lib; {
    description = "Parse C++ header files using ply.lex to generate navigable class tree representing the class structure";
    homepage = "https://sourceforge.net/projects/cppheaderparser/";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
