{ lib, buildPythonPackage, fetchPypi, setuptools, mkdocs }:

buildPythonPackage rec {
  pname = "mkdocs-exclude";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12bjkgmhrd2c7hjszrvw6yp0p4b8y7sb3cadg23p0g60p598xpxp";
  };
  nativeBuildInputs = [ setuptools ];
  propagatedBuildInputs = [ mkdocs ];

  meta = with lib; {
    description = "A plugin for mkdocs to exclude arbitrary paths and files";
    homepage = https://github.com/apenwarr/mkdocs-exclude;
    license = licenses.asl20;
    maintainers = [ maintainers.spacefrogg ];
  };
}
