{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm, isPy27, pytestCheckHook
, requests, arrow, logfury, tqdm }:

buildPythonPackage rec {
  pname = "b2sdk";
  version = "1.1.4";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g527qdda105r5g9yjh4lxzlmz34m2bdz8dydqqy09igdsmiyi9j";
  };

  pythonImportsCheck = [ "b2sdk" ];

  nativebuildInputs = [ setuptools_scm ];
  requiredPythonModules = [ requests arrow logfury tqdm ];

  # requires unpackaged dependencies like liccheck
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Client library and utilities for access to B2 Cloud Storage (backblaze).";
    homepage = "https://github.com/Backblaze/b2-sdk-python";
    license = licenses.mit;
  };
}
