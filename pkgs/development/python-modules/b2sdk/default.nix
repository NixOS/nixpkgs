{ lib, buildPythonPackage, fetchPypi, setuptools-scm, isPy27
, arrow, logfury, requests, rst2ansi, tqdm }:

buildPythonPackage rec {
  pname = "b2sdk";
  version = "1.7.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zkjwz2r9jlf31gj5bnw6h9mqapjn8rndxmz7wsr5iaj3wp5fzpi";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'setuptools_scm<6.0' 'setuptools_scm'
    substituteInPlace requirements.txt \
      --replace 'arrow>=0.8.0,<1.0.0' 'arrow'
  '';

  pythonImportsCheck = [ "b2sdk" ];

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    arrow
    logfury
    requests
    rst2ansi
    tqdm
  ];

  patches = [
    # https://github.com/Backblaze/b2-sdk-python/issues/201
    ./0001-Upgrade-arrow.patch
  ];

  # requires unpackaged dependencies like liccheck
  doCheck = false;

  meta = with lib; {
    description = "Client library and utilities for access to B2 Cloud Storage (backblaze).";
    homepage = "https://github.com/Backblaze/b2-sdk-python";
    license = licenses.mit;
    maintainers = [ maintainers.uri-canva ];
  };
}
