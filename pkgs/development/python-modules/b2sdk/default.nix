{ lib, buildPythonPackage, fetchPypi, setuptools_scm, isPy27, pytestCheckHook
, requests, arrow, logfury, tqdm }:

buildPythonPackage rec {
  pname = "b2sdk";
  version = "1.2.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e46ff9d47a9b90d8b9beab1969fcf4920300b02e20e6bf0745be04e09e8a6ff";
  };

  pythonImportsCheck = [ "b2sdk" ];

  nativebuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ requests arrow logfury tqdm ];

  # requires unpackaged dependencies like liccheck
  doCheck = false;

  meta = with lib; {
    description = "Client library and utilities for access to B2 Cloud Storage (backblaze).";
    homepage = "https://github.com/Backblaze/b2-sdk-python";
    license = licenses.mit;
  };
}
