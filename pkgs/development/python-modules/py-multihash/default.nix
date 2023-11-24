{ lib
, base58
, buildPythonPackage
, fetchFromGitHub
, morphys
, pytestCheckHook
, pythonOlder
, six
, varint
}:

buildPythonPackage rec {
  pname = "py-multihash";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "multiformats";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-z1lmSypGCMFWJNzNgV9hx/IStyXbpd5jvrptFpewuOA=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner', " ""
  '';

  propagatedBuildInputs = [
    base58
    morphys
    six
    varint
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "multihash"
  ];

  meta = with lib; {
    description = "Self describing hashes - for future proofing";
    homepage = "https://github.com/multiformats/py-multihash";
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
