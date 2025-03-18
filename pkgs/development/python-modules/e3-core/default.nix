{
  autoPatchelfHook,
  buildPythonPackage,
  colorama,
  distro,
  fetchFromGitHub,
  lib,
  packaging,
  psutil,
  python-dateutil,
  pyyaml,
  requests,
  requests-cache,
  requests-toolbelt,
  stdenv,
  setuptools,
  stevedore,
  tqdm,
}:

buildPythonPackage rec {
  pname = "e3-core";
  version = "22.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AdaCore";
    repo = "e3-core";
    rev = "refs/tags/v${version}";
    hash = "sha256-7csZYohU89uavSMPOKGJ8HClmtiweGSghyR7QgFfSY8=";
  };

  patches = [ ./0001-use-distro-over-ld.patch ];

  nativeBuildInputs = [
    autoPatchelfHook
    setuptools
  ];

  propagatedBuildInputs =
    [
      colorama
      packaging
      pyyaml
      python-dateutil
      requests
      requests-cache
      requests-toolbelt
      tqdm
      stevedore
    ]
    ++ lib.optional stdenv.isLinux [
      # See setup.py:24. These are required only on Linux. Darwin has its own set
      # of requirements.
      psutil
      distro
    ];

  pythonImportsCheck = [ "e3" ];

  # e3-core is tested with tox; it's hard to test without internet.
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/AdaCore/e3-core/releases/tag/${src.rev}";
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
