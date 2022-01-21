{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "jsmin";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0959a121ef94542e807a674142606f7e90214a2b3d1eb17300244bbb5cc2bfc";
  };

  meta = with lib; {
    description = "JavaScript minifier";
    homepage = "https://github.com/tikitu/jsmin/";
    license = licenses.mit;
  };
}
