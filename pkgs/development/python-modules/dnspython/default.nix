{
  stdenv,
  lib,
  aioquic,
  buildPythonPackage,
  cacert,
  cryptography,
  curio,
  fetchPypi,
  h2,
  httpcore,
  httpx,
  idna,
  hatchling,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-toolbelt,
  sniffio,
  trio,
}:

buildPythonPackage rec {
  pname = "dnspython";
  version = "2.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zpxDLtoNyRz2GKXO3xpOFCZRGWu80sgOie1akH5c+vE=";
  };

  nativeBuildInputs = [ hatchling ];

  optional-dependencies = {
    DOH = [
      httpx
      h2
      requests
      requests-toolbelt
      httpcore
    ];
    IDNA = [ idna ];
    DNSSEC = [ cryptography ];
    trio = [ trio ];
    curio = [
      curio
      sniffio
    ];
    DOQ = [ aioquic ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ cacert ] ++ optional-dependencies.DNSSEC;

  # don't run live tests
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NO_INTERNET = 1;
  };

  disabledTests = [
    # dns.exception.SyntaxError: protocol not found
    "test_misc_good_WKS_text"
  ];

  pythonImportsCheck = [ "dns" ];

  meta = with lib; {
    description = "DNS toolkit for Python";
    homepage = "https://www.dnspython.org";
    changelog = "https://github.com/rthalley/dnspython/blob/v${version}/doc/whatsnew.rst";
    license = with licenses; [ isc ];
    maintainers = with maintainers; [ gador ];
  };
}
