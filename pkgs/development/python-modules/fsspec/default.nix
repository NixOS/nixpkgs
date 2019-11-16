{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fsspec";
  version = "0.5.2";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6531a5fa9ea6bf27a5180d225558a8a7aa5d7c3cbf7e8b146dd37ac699017937";
  };

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "A specification that python filesystems should adhere to.";
    homepage = "https://github.com/intake/filesystem_spec";
    license = licenses.bsd3;
  };
}
