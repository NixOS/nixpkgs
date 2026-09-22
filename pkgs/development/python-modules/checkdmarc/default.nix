{
  lib,
  stdenv,
  buildPythonPackage,
  cryptography,
  dnspython,
  expiringdict,
  fetchFromGitHub,
  hatchling,
  httpx,
  iana-etc,
  importlib-resources,
  libredirect,
  pem,
  publicsuffixlist,
  pyleri,
  pyopenssl,
  pytestCheckHook,
  requests,
  timeout-decorator,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "checkdmarc";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domainaware";
    repo = "checkdmarc";
    tag = finalAttrs.version;
    hash = "sha256-yyyaA0gLnRpyf1MueHWd67kzXDMOJYd5CHzAG/mBIA0=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "pyopenssl"
    "xmltodict"
  ];

  build-system = [ hatchling ];

  dependencies = [
    cryptography
    dnspython
    expiringdict
    httpx
    importlib-resources
    pem
    publicsuffixlist
    pyleri
    pyopenssl
    requests
    timeout-decorator
    xmltodict
  ]
  ++ dnspython.optional-dependencies.doh;

  nativeCheckInputs = [
    httpx
    pytestCheckHook
  ]
  ++ httpx.optional-dependencies.http2;

  pythonImportsCheck = [ "checkdmarc" ];

  preCheck = lib.optionalString stdenv.hostPlatform.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf) \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';

  disabledTests = [
    # Tests require network access
    "testBIMI"
    "testCheckSoaDelegatedChildZoneLive"
    "testCheckSoaFallsBackToBaseDomainLive"
    "testDMARCPctLessThan100Warning"
    "testDNSSEC"
    "testDnssecFalseWhenNoKey"
    "testGetDnskeyCache"
    "testIncludeMissingSPF"
    "testKnownGood"
    "testSPFMissingARecord"
    "testSPFMissingMXRecord"
    "testSplitSPFRecord"
    "testTooManySPFDNSLookups"
    "testTooManySPFVoidDNSLookups"
  ];

  meta = {
    description = "Parser for SPF and DMARC DNS records";
    homepage = "https://github.com/domainaware/checkdmarc";
    changelog = "https://github.com/domainaware/checkdmarc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "checkdmarc";
  };
})
