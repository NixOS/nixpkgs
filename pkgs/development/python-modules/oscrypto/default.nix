{ lib
, stdenv
, asn1crypto
, buildPythonPackage
, fetchFromGitHub
, openssl
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "oscrypto";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wbond";
    repo = pname;
    rev = version;
    hash = "sha256-CmDypmlc/kb6ONCUggjT1Iqd29xNSLRaGh5Hz36dvOw=";
  };

  postPatch = ''
    for file in oscrypto/_openssl/_lib{crypto,ssl}_c{ffi,types}.py; do
      substituteInPlace $file \
        --replace "get_library('crypto', 'libcrypto.dylib', '42')" "'${openssl.out}/lib/libcrypto${stdenv.hostPlatform.extensions.sharedLibrary}'" \
        --replace "get_library('ssl', 'libssl', '44')" "'${openssl.out}/lib/libssl${stdenv.hostPlatform.extensions.sharedLibrary}'"
    done
  '';

  propagatedBuildInputs = [
    asn1crypto
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "oscrypto"
  ];

  doCheck = !stdenv.isDarwin;

  disabledTests = [
    # Tests require network access
    "TLSTests"
    "TrustListTests"
  ];

  meta = with lib; {
    description = "Encryption library for Python";
    homepage = "https://github.com/wbond/oscrypto";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
