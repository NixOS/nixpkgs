{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  geckodriver,
  curl,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "xsser";
  version = "1.9";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "epsylon";
    repo = "xsser";
    tag = "xsser-v${finalAttrs.version}";
    hash = "sha256-wq8BGeBxDW/ux1X5seUTb6bGdKUTBgkRVeqkm3sVLPU=";
  };

  postPatch = ''
    substituteInPlace core/curlcontrol.py \
      --replace-fail 'open("core/fuzzing/user-agents.txt")' 'open(os.path.join(os.path.dirname(__file__), "fuzzing", "user-agents.txt"))' \
      --replace-fail 'open("fuzzing/user-agents.txt")' 'open(os.path.join(os.path.dirname(__file__), "fuzzing", "user-agents.txt"))'

    substituteInPlace core/dork.py \
      --replace-fail 'import urllib.request, urllib.error, urllib.parse, traceback, re, random, time, ssl, base64, warnings' 'import os, urllib.request, urllib.error, urllib.parse, traceback, re, random, time, ssl, base64, warnings' \
      --replace-fail 'open("core/fuzzing/user-agents.txt")' 'open(os.path.join(os.path.dirname(__file__), "fuzzing", "user-agents.txt"))' \
      --replace-fail 'open("fuzzing/user-agents.txt")' 'open(os.path.join(os.path.dirname(__file__), "fuzzing", "user-agents.txt"))'

    substituteInPlace core/main.py \
      --replace-fail 'open("core/fuzzing/user-agents.txt")' 'open(os.path.join(os.path.dirname(__file__), "fuzzing", "user-agents.txt"))' \
      --replace-fail 'open("fuzzing/user-agents.txt")' 'open(os.path.join(os.path.dirname(__file__), "fuzzing", "user-agents.txt"))' \
      --replace-fail "open('core/fuzzing/dorks.txt')" "open(os.path.join(os.path.dirname(__file__), 'fuzzing', 'dorks.txt'))" \
      --replace-fail "os.path.exists('core/fuzzing/dorks.txt')" "os.path.exists(os.path.join(os.path.dirname(__file__), 'fuzzing', 'dorks.txt'))"
  '';

  postInstall = ''
    install -Dm644 core/fuzzing/user-agents.txt "$out/${python3Packages.python.sitePackages}/core/fuzzing/user-agents.txt"
    install -Dm644 core/fuzzing/dorks.txt "$out/${python3Packages.python.sitePackages}/core/fuzzing/dorks.txt"
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies =
    with python3Packages;
    [
      beautifulsoup4
      ddgs
      fpdf2
      geoip
      pygobject3
      pycurl
      selenium
    ]
    ++ [ geckodriver ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ] ++ [ curl ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  preFixup = ''
    makeWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        geckodriver
        curl
      ]
    })
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automatic framework to detect, exploit and report XSS vulnerabilities in web-based applications";
    homepage = "https://github.com/epsylon/xsser";
    changelog = "https://github.com/epsylon/xsser/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "xsser";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
