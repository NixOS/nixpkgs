{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "genzshcomp";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c77d007cc32cdff836ecf8df6192371767976c108a75b055e057bb6f4a09cd42";
  };

  buildInputs = [ setuptools ];

  meta = with stdenv.lib; {
    description = "Automatically generated zsh completion function for Python's option parser modules";
    homepage = http://bitbucket.org/hhatto/genzshcomp/;
    license = licenses.bsd0;
  };

}
