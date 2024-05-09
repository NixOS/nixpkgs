{ lib
, buildPythonPackage
, fetchFromGitHub
, asn1crypto
, autoconf
, automake
, cffi
, libtool
, pkg-config
, pytestCheckHook
, python
, pythonOlder
, secp256k1
}:

buildPythonPackage rec {
  pname = "coincurve";
  version = "19.0.1";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ofek";
    repo = "coincurve";
    rev = "refs/tags/v${version}";
    hash = "sha256-T60iKRrc8/t86nqf8/R4971SjOw586YNCWWBuLd9MjM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace ", 'requests'" ""

    # don't try to load .dll files
    rm coincurve/_windows_libsecp256k1.py
    cp -r --no-preserve=mode ${secp256k1.src} libsecp256k1
    patchShebangs secp256k1/autogen.sh
  '';

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
  ];

  propagatedBuildInputs = [
    asn1crypto
    cffi
  ];

  preCheck = ''
    # https://github.com/ofek/coincurve/blob/master/tox.ini#L20-L22=
    rm -rf coincurve

    # don't run benchmark tests
    rm tests/test_bench.py
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "coincurve"
  ];

  meta = with lib; {
    description = "Cross-platform bindings for libsecp256k1";
    homepage = "https://github.com/ofek/coincurve";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ ];
  };
}
