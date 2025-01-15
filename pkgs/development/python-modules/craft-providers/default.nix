{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  packaging,
  platformdirs,
  pydantic_1,
  pyyaml,
  requests-unixsocket,
  setuptools,
  setuptools-scm,
  urllib3,
  pytest-check,
  pytest-mock,
  pytestCheckHook,
  responses,
  freezegun,
  pytest-subprocess,
  pytest-logdog,
}:

buildPythonPackage rec {
  pname = "craft-providers";
  version = "1.23.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-providers";
    rev = "refs/tags/${version}";
    hash = "sha256-opVgOtbwZD+uQJ10Q8QlgQaS9KjRFnQ4h98Ak7Ze5qQ=";
  };

  patches = [
    # This lib will try to inject snaps *from the host system* into the build
    # system. This patch short-circuits that logic and ensures that snaps are
    # installed on the build system from the snap store - because there is no
    # snapd on NixOS hosts that can be used for the injection. This patch will
    # likely never be accepted upstream.
    ./inject-snaps.patch
  ];

  postPatch = ''
    substituteInPlace craft_providers/lxd/installer.py \
      --replace-fail "/var/snap/lxd/common/lxd/unix.socket" "/var/lib/lxd/unix.socket"

    substituteInPlace craft_providers/__init__.py \
      --replace-fail "dev" "${version}"

    # The urllib3 incompat: https://github.com/msabramo/requests-unixsocket/pull/69
    # This is already patched in nixpkgs.
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==69.1.1" "setuptools" \
      --replace-fail "urllib3<2" "urllib3"
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    packaging
    platformdirs
    pydantic_1
    pyyaml
    requests-unixsocket
    urllib3
  ];

  pythonImportsCheck = [ "craft_providers" ];

  nativeCheckInputs = [
    freezegun
    pytest-check
    pytest-mock
    pytest-subprocess
    pytest-logdog
    pytestCheckHook
    responses
  ];

  preCheck = ''
    mkdir -p check-phase
    export HOME="$(pwd)/check-phase"
  '';

  pytestFlagsArray = [ "tests/unit" ];

  disabledTestPaths = [
    # Relies upon "logassert" python package which isn't in nixpkgs
    "tests/unit/bases/test_ubuntu_buildd.py"
    "tests/unit/bases/test_centos_7.py"
    "tests/unit/bases/test_almalinux.py"
    "tests/unit/actions/test_snap_installer.py"
    # Relies upon "pytest-time" python package which isn't in nixpkgs
    "tests/unit/multipass"
    "tests/unit/lxd"
    "tests/unit/test_base.py"
    "tests/unit/util/test_retry.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interfaces for instantiating and controlling a variety of build environments";
    homepage = "https://github.com/canonical/craft-providers";
    changelog = "https://github.com/canonical/craft-providers/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
