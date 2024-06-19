{
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
  version = "2.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6PD5wjp7fLmd7WTmw6bz5wHXj1DFXgArg53qciXP98w=";
  };

  nativeBuildInputs = [ hatchling ];

  passthru.optional-dependencies = {
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

  checkInputs = [ cacert ] ++ passthru.optional-dependencies.DNSSEC;

  disabledTests = [
    # dns.exception.SyntaxError: protocol not found
    "test_misc_good_WKS_text"
  ];

  pythonImportsCheck = [ "dns" ];

  meta = with lib; {
    description = "A DNS toolkit for Python";
    homepage = "https://www.dnspython.org";
    changelog = "https://github.com/rthalley/dnspython/blob/v${version}/doc/whatsnew.rst";
    license = with licenses; [ isc ];
    maintainers = with maintainers; [ gador ];
  };
}
