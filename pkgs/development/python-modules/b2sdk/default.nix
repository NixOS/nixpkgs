{ lib, buildPythonPackage, fetchPypi, setuptools_scm, isPy27, pytestCheckHook
, requests, arrow, logfury, tqdm }:

buildPythonPackage rec {
  pname = "b2sdk";
  version = "1.4.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb82cbaef5dd7499b62622010fc8e328944ca8cbdd00b485530ab6600de1129d";
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
