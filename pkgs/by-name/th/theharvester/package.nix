{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "theharvester";
  version = "4.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laramies";
    repo = "theharvester";
    tag = version;
    hash = "sha256-Sui9PKpp+iMxCUbFcZE2OVDiBCxXLwR9iuXFIbd0P0k=";
  };

  pythonRelaxDeps = true;

  pythonRemoveDeps = [ "winloop" ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    aiodns
    aiofiles
    aiohttp
    aiomultiprocess
    aiosqlite
    beautifulsoup4
    censys
    certifi
    dnspython
    fastapi
    lxml
    netaddr
    ujson
    playwright
    plotly
    pyppeteer
    python-dateutil
    pyyaml
    requests
    retrying
    shodan
    slowapi
    starlette
    uvicorn
    uvloop
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest
    pytest-asyncio
  ];

  # We don't run other tests (discovery modules) because they require network access
  checkPhase = ''
    runHook preCheck
    pytest tests/test_myparser.py
    runHook postCheck
  '';

  meta = {
    description = "Gather E-mails, subdomains and names from different public sources";
    longDescription = ''
      theHarvester is a very simple, yet effective tool designed to be used in the early
      stages of a penetration test. Use it for open source intelligence gathering and
      helping to determine an entity's external threat landscape on the internet. The tool
      gathers emails, names, subdomains, IPs, and URLs using multiple public data sources.
    '';
    homepage = "https://github.com/laramies/theHarvester";
    changelog = "https://github.com/laramies/theHarvester/releases/tag/${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      c0bw3b
      fab
      treemo
    ];
    mainProgram = "theHarvester";
  };
}
