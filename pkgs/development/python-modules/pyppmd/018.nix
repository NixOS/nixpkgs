{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pyppmd";
  version = "0.18.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bHTOKCEwROM6WVJ5AZ6NcVEtXYGIgm0QbfkIPyswBsQ=";
  };

  doCheck = false;
  propagatedBuildInputs = [
    setuptools-scm
  ];

  meta = with lib; {
    homepage = "http://github.com/miurahr/pyppmd";
    description = "provides classes and functions for compressing and decompressing text data, using PPM compression algorithm which has several variations of implementations";
    license = licenses.lgpl21Plus;
  };
}
