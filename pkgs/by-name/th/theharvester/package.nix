{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "theharvester";
<<<<<<< HEAD
  version = "4.9.0";
=======
  version = "4.8.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "laramies";
    repo = "theharvester";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-2PiwfLqpVa29//DJJRM/zw2xFHI4cp1WE4VKsJ/zEro=";
=======
    hash = "sha256-Sui9PKpp+iMxCUbFcZE2OVDiBCxXLwR9iuXFIbd0P0k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    httpx
    lxml
    netaddr
=======
    lxml
    netaddr
    ujson
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    playwright
    plotly
    pyppeteer
    python-dateutil
    pyyaml
<<<<<<< HEAD
=======
    requests
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    retrying
    shodan
    slowapi
    starlette
<<<<<<< HEAD
    ujson
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    changelog = "https://github.com/laramies/theHarvester/releases/tag/${src.tag}";
=======
    changelog = "https://github.com/laramies/theHarvester/releases/tag/${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      c0bw3b
      fab
      treemo
    ];
    mainProgram = "theHarvester";
  };
}
