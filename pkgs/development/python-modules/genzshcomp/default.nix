{ stdenv
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "genzshcomp";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d28ae62b1b2727f32dc7606bc58201b8c12894ad3d1d4fdb40e1f951e3ae8f85";
  };

  buildInputs = [ setuptools ];

  meta = with stdenv.lib; {
    description = "Automatically generated zsh completion function for Python's option parser modules";
    homepage = https://bitbucket.org/hhatto/genzshcomp/;
    license = licenses.bsd0;
  };

}
