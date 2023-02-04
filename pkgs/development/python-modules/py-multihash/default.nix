{ base58
, buildPythonPackage
, fetchFromGitHub
, lib
, morphys
, pytest-runner
, pytestCheckHook
, pythonOlder
, six
, varint
}:

buildPythonPackage rec {
  pname = "py-multihash";
  version = "2.0.1";
  disabled = pythonOlder "3.4";

  src = fetchFromGitHub {
    owner = "multiformats";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-z1lmSypGCMFWJNzNgV9hx/IStyXbpd5jvrptFpewuOA=";
  };

  nativeBuildInputs = [
    pytest-runner
  ];

  propagatedBuildInputs = [
    base58
    morphys
    six
    varint
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "multihash" ];

  meta = with lib; {
    description = "Self describing hashes - for future proofing";
    homepage = "https://github.com/multiformats/py-multihash";
    license = licenses.mit;
    maintainers = with maintainers; [ rakesh4g ];
  };
}
