{ buildPythonPackage, fetchPypi, setuptools_scm
, tempora, six }:

buildPythonPackage rec {
  pname = "jaraco.logging";
  version = "1.5.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "199pgwx9ziab3gxg6p0c24z8dp3bjpsvvshnmlph9zjsssq0xc93";
  };
  doCheck = false;
  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ tempora six ];
}
