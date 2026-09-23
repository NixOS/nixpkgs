{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  azure-identity,
  azure-monitor-ingestion,
  boto3,
  dateparser,
  dnspython,
  elasticsearch-dsl,
  elasticsearch,
  expiringdict,
  kafka-python,
  lxml,
  mailsuite,
  maxminddb,
  nixosTests,
  opensearch-py,
  publicsuffixlist,
  pygelf,
  pyyaml,
  requests,
  tqdm,
  urllib3,
  xmltodict,

  # test
  iana-etc,
  libredirect,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "parsedmarc";
  version = "11.0.2";
  pyproject = true;

  outputs = [
    "out"
    "dashboard"
  ];

  src = fetchFromGitHub {
    owner = "domainaware";
    repo = "parsedmarc";
    tag = finalAttrs.version;
    hash = "sha256-e7AU09oMV5G56mQXKSYlMVrZ7is5zsa2hmj/770sWig=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires_python = ">=3.10,<3.15"' ""

    substituteInPlace dashboards/grafana/Grafana-DMARC_Reports.json \
      --replace-fail elasticsearch grafana-opensearch-datasource \
      --replace-fail Elasticsearch OpenSearch

    install -D dashboards/grafana/Grafana-DMARC_Reports.json $dashboard/DMARC_Reports.json
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    azure-identity
    azure-monitor-ingestion
    boto3
    dateparser
    dnspython
    elasticsearch
    elasticsearch-dsl
    expiringdict
    kafka-python
    lxml
    mailsuite
    maxminddb
    opensearch-py
    publicsuffixlist
    pygelf
    pyyaml
    requests
    tqdm
    urllib3
    xmltodict
  ]
  ++ mailsuite.optional-dependencies.gmail
  ++ mailsuite.optional-dependencies.msgraph;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = lib.optionalString stdenv.hostPlatform.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf) \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';

  disabledTests = [
    # contacts DNS servers at 1.1.1.1 and 8.8.8.8
    "test_general_dns_settings_with_defaults"
    # AssertionError
    "testWithoutAssumeUtcNaiveIsLocal"
  ];

  pythonImportsCheck = [ "parsedmarc" ];

  passthru = {
    tests = nixosTests.parsedmarc;
  };

  meta = {
    description = "Python module and CLI utility for parsing DMARC reports";
    homepage = "https://domainaware.github.io/parsedmarc/";
    changelog = "https://github.com/domainaware/parsedmarc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ talyz ];
    mainProgram = "parsedmarc";
  };
})
