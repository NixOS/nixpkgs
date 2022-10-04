{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyzstd";
  version = "0.15.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rE7atdOVU0Po9/KH5izSiCkH1GvLpLQGoen4SqKIdHI=";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/animalize/pyzstd";
    description = "Python bindings to Zstandard (zstd) compression library";
    license = licenses.bsd3;
  };
}
