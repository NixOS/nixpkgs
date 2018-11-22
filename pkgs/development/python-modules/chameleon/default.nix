{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Chameleon";
  version = "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a83jf211mqjhgbd3abqyrn4mp4vb077ql8fydmv80xg3whrf3yb";
  };

  meta = with stdenv.lib; {
    homepage = https://chameleon.readthedocs.io/;
    description = "Fast HTML/XML Template Compiler";
    license = licenses.bsd0;
    maintainers = with maintainers; [ garbas domenkozar ];
  };

}
