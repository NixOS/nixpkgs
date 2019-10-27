{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fsspec";
  version = "0.4.5";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "824e406f5628cfde927ac945acf4ff70bc712b8bd204d7b99fe127993254db70";
  };

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A specification that python filesystems should adhere to.";
    homepage = "https://github.com/intake/filesystem_spec";
    license = licenses.bsd3;
  };
}
