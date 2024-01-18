{ lib
, buildPythonPackage
, fetchFromGitHub
, asn1tools
, coincurve
, eth-hash
, eth-typing
, eth-utils
, factory-boy
, hypothesis
, isPyPy
, pyasn1
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "eth-keys";
  version = "0.4.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "eth-keys";
    rev = "v${version}";
    hash = "sha256-jG/jJPM4t3z6UQIdc8L6y0DxZiGx5pVuGL8XwbIt60o=";
  };

  propagatedBuildInputs = [
    eth-typing
    eth-utils
  ];

  nativeCheckInputs = [
    asn1tools
    factory-boy
    hypothesis
    pyasn1
    pytestCheckHook
  ] ++ passthru.optional-dependencies.coincurve
  ++ lib.optional (!isPyPy) eth-hash.optional-dependencies.pysha3
  ++ lib.optional isPyPy eth-hash.optional-dependencies.pycryptodome;

  disabledTests = [
    # tests are broken
    "test_compress_decompress_inversion"
    "test_public_key_generation_is_equal"
    "test_signing_is_equal"
    "test_native_to_coincurve_recover"
    "test_public_key_compression_is_equal"
    "test_public_key_decompression_is_equal"
    "test_signatures_with_high_s"
    # timing sensitive
    "test_encode_decode_pairings"
  ];

  pythonImportsCheck = [ "eth_keys" ];

  passthru.optional-dependencies = {
    coincurve = [ coincurve ];
  };

  meta = with lib; {
    description = "Common API for Ethereum key operations";
    homepage = "https://github.com/ethereum/eth-keys";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
