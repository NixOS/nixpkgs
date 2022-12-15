{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "inflate64";
  version = "0.3.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-gfuOaQ+8uS59Pmdp7Exvv6u4iq3md/YbL0yZh0U4v2Q=";
  };

  doCheck = false;
  propagatedBuildInputs = [
    setuptools-scm
  ];

  meta = with lib; {
    description = "provide Deflater and Inflater class to compress and decompress with Enhanced Deflate compression algorithm";
    license = licenses.lgpl2Plus;
  };
}
