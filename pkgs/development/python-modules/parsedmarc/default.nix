{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,

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
  pytestCheckHook,
}:

let
  dashboard = fetchurl {
    url = "https://raw.githubusercontent.com/domainaware/parsedmarc/77331b55c54cb3269205295bd57d0ab680638964/grafana/Grafana-DMARC_Reports.json";
    sha256 = "0wbihyqbb4ndjg79qs8088zgrcg88km8khjhv2474y7nzjzkf43i";
  };
in
buildPythonPackage rec {
  pname = "parsedmarc";
  version = "10.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "domainaware";
    repo = "parsedmarc";
    tag = version;
    hash = "sha256-dFwlcbR8NNKrDBoKPDX9M82tTK5aCbeP3KMF/BctgMc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'requires_python = ">=3.10,<3.15"' ""
  '';

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    "elasticsearch"
    "elasticsearch-dsl"
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

  disabledTests = [
    # contacts DNS servers at 1.1.1.1 and 8.8.8.8
    "test_general_dns_settings_with_defaults"
  ];

  pythonImportsCheck = [ "parsedmarc" ];

  passthru = {
    inherit dashboard;
    tests = nixosTests.parsedmarc;
  };

  meta = {
    description = "Python module and CLI utility for parsing DMARC reports";
    homepage = "https://domainaware.github.io/parsedmarc/";
    changelog = "https://github.com/domainaware/parsedmarc/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ talyz ];
    mainProgram = "parsedmarc";
  };
}
