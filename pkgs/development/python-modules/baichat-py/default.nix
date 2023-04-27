{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, aiohttp
}:

buildPythonPackage rec {
  pname = "baichat-py";
  version = "0.2.1";

  src = fetchPypi {
    inherit version;
    pname = "baichat_py";
    hash = "sha256-g03jyNVEyXJPCJ17gFG6xXh9UZt2nOyskFQFnvVZsPs=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # No tests implemented.
  doCheck = false;
}