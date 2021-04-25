{ lib, buildPythonPackage, fetchPypi, setuptools-scm, isPy27, pytestCheckHook
, requests, arrow, logfury, tqdm }:

buildPythonPackage rec {
  pname = "b2sdk";
  version = "1.6.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6fjreuMUC056ljddfAidfBbJkvEDndB/dIkx1bF7efs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'setuptools_scm<6.0' 'setuptools_scm'
    substituteInPlace requirements.txt \
      --replace 'arrow>=0.8.0,<1.0.0' 'arrow'
  '';

  pythonImportsCheck = [ "b2sdk" ];

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ requests arrow logfury tqdm ];

  # requires unpackaged dependencies like liccheck
  doCheck = false;

  meta = with lib; {
    description = "Client library and utilities for access to B2 Cloud Storage (backblaze).";
    homepage = "https://github.com/Backblaze/b2-sdk-python";
    license = licenses.mit;
  };
}
