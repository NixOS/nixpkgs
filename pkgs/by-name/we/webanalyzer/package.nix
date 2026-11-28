{
  lib,
  python3,
  nmap,
  fetchFromGitHub,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "webanalyzer";
  version = "3.6.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "frkndncr";
    repo = "WebAnalyzer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yMIL/rhED9Jbz7iQCMJx3VGlFW+rHiqRZgTeWLspa3s=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    aiohttp
    beautifulsoup4
    curl-cffi
    dnspython
    fake-useragent
    fastapi
    httpx
    iso3166
    langdetect
    mysql-connector
    nest-asyncio
    phonenumbers
    psutil
    pycountry
    pyjwt
    pyopenssl
    pydantic
    python-multipart
    python-nmap
    python-whois
    requests
    rich
    tabulate
    timezonefinder
    tldextract
    tqdm
    urllib3
    uvicorn
    validators
  ];

  # python-nmap shells out to the nmap binary at runtime
  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ nmap ]}"
  ];

  # Project has no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for comprehensive domain analysis";
    homepage = "https://github.com/frkndncr/WebAnalyzer";
    changelog = "https://github.com/frkndncr/WebAnalyzer/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "webanalyzer";
  };
})
