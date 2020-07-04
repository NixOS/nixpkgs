{ stdenv, buildPythonPackage, fetchPypi, coverage, nose, six }:

buildPythonPackage rec {
  pname = "attrdict";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35c90698b55c683946091177177a9e9c0713a0860f0e049febd72649ccd77b70";
  };

  propagatedBuildInputs = [ coverage nose six ];

  meta = with stdenv.lib; {
    description = "A dict with attribute-style access";
    homepage = "https://github.com/bcj/AttrDict";
    license = licenses.mit;
  };
}
