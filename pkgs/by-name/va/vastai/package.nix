{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  nix-update-script,
  openssh,
  python3Packages,
  rsync,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "vastai";
  version = "1.5.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vast-ai";
    repo = "vast-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ovxFLPBPHJi/DMauS0Yuk9HWfcS+K/gJTAwPf/MLdoA=";
  };

  patches = [
    (fetchpatch2 {
      # Upstream credential hardening: https://github.com/vast-ai/vast-cli/pull/505
      url = "https://github.com/vast-ai/vast-cli/commit/0889fe32e5bf3228074436dd9688f6a1fdc649e8.patch";
      hash = "sha256-g3Nje1M1SnXK3eJ26XE13+/Wdg0pv63AKU5wbgZacMM=";
    })
  ];

  # distutils was removed from Python 3.12. Use setuptools' maintained copy.
  # The borb 2.x Document class lives in the document submodule.
  postPatch = ''
    substituteInPlace vastai/serverless/server/lib/backend.py \
      --replace-fail "from distutils.util import strtobool" \
      "from setuptools._distutils.util import strtobool"

    substituteInPlace vastai/pdf/vast_pdf.py \
      --replace-fail "from borb.pdf.document import Document" \
      "from borb.pdf.document.document import Document"
  '';

  build-system = with python3Packages; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python3Packages; [
    aiodns
    aiohttp
    anyio
    argcomplete
    borb_2
    cryptography
    curlify
    pillow
    psutil
    pycares
    pycryptodome
    pyparsing
    python-dateutil
    requests
    rich
    setuptools
    typing-extensions
    urllib3
    xdg
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      openssh
      rsync
    ])
    "--set-default"
    "VASTAI_NO_UPDATE_CHECK"
    "1"
  ];

  # Upstream pins these to the versions in its release lock file. The selected
  # nixpkgs versions are API-compatible and exercised by the offline test suite.
  pythonRelaxDeps = [
    "cryptography"
    "pillow"
    "pycares"
  ];

  nativeCheckInputs = with python3Packages; [
    pyopenssl
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests" ];
  disabledTestMarks = [
    "integration"
    "live"
  ];
  disabledTests = [
    # These tests target a removed `compress` argument; 1.5.6 always creates
    # gzip-compressed deployment archives.
    "test_contains_config_json"
    "test_module_becomes_deployment_py"
    "test_package_becomes_deployment_dir"
    "test_extra_files_absolute_dest_paths"
    "test_extra_files_relative_dest_paths"
    "test_compressed_tarball_is_valid"
    "test_uncompressed_tarball_is_valid"
    "test_tar_extract_module_deployment"
    "test_tar_extract_package_deployment"
    "test_tar_extract_absolute_extra_files"
    "test_tar_extract_relative_extra_files"
    "test_tar_extract_compressed"
  ];

  pythonImportsCheck = [
    "vastai"
    "vastai.cli.main"
    "vastai.pdf.vast_pdf"
    "vastai.serverless.remote.serve_deployment"
    "vastai_sdk"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];

  postCheck = ''
    $out/bin/vastai --help >/dev/null
    test -x $out/bin/serve-vast-deployment
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI and SDK for the Vast.ai GPU cloud service";
    homepage = "https://vast.ai/";
    changelog = "https://github.com/vast-ai/vast-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.samuela ];
    mainProgram = "vastai";
  };
})
