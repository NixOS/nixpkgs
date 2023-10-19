{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, requests
, pytestCheckHook
, mock
, nose
, pycrypto
}:

buildPythonPackage rec {
  pname = "rauth";
  version = "0.7.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "litl";
    repo = "rauth";
    rev = version;
    hash = "sha256-wRKZbxZCEfihOaJM8sk8438LE++KJWxdOGImpL1gHa4=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/litl/rauth/pull/211
      name = "fix-pycrypdodome-replacement-for-pycrypto.patch";
      url = "https://github.com/litl/rauth/commit/7fb3b7bf1a1869a52cf59ee3eb607d318e97265c.patch";
      hash = "sha256-jiAIw+VQ2d/bkm2brqfY1RUrNGf+lsMPnoI91gGUS6o=";
    })
  ];

  propagatedBuildInputs = [
    requests
  ];

  pythonImportsCheck = [ "rauth" ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
    nose
    pycrypto
  ];

  meta = with lib; {
    description = "A Python library for OAuth 1.0/a, 2.0, and Ofly";
    homepage = "https://github.com/litl/rauth";
    changelog = "https://github.com/litl/rauth/blob/${src.rev}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}

