{
  lib,
  stdenv,
  autoPatchelfHook,
  buildPythonPackage,
  colorama,
  distro,
  fetchFromGitHub,
  packaging,
  psutil,
  python-dateutil,
  pythonOlder,
  pyyaml,
  requests-cache,
  requests-toolbelt,
  requests,
  resolvelib,
  setuptools,
  stevedore,
  tqdm,
}:

buildPythonPackage rec {
  pname = "e3-core";
  version = "22.10.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "e3-core";
    tag = "v${version}";
    hash = "sha256-LHWtgIvbS1PaF85aOpdhR0rWQGRUtbY0Qg1SZxQOsSc=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ autoPatchelfHook ];

  dependencies = [
    colorama
    packaging
    python-dateutil
    pyyaml
    requests
    requests-cache
    requests-toolbelt
    resolvelib
    stevedore
    tqdm
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux [
    # See https://github.com/AdaCore/e3-core/blob/v22.6.0/pyproject.toml#L37-L42
    # These are required only on Linux. Darwin has its own set of requirements
    psutil
    distro
  ];

  pythonImportsCheck = [ "e3" ];

  # e3-core is tested with tox; it's hard to test without internet.
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/AdaCore/e3-core/releases/tag/${src.tag}";
    homepage = "https://github.com/AdaCore/e3-core/";
    description = "Core framework for developing portable automated build systems";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ atalii ];
    mainProgram = "e3";
    # See the comment regarding distro and psutil. Other platforms are supported
    # upstream, but not by this package.
    platforms = platforms.linux;
  };
}
