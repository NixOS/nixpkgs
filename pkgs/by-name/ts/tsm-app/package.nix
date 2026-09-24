# Ready to copy into nixpkgs as pkgs/by-name/ts/tsm-app/package.nix.
#
# This differs from flake.nix on purpose: nixpkgs fetches a release tarball
# rather than building the working tree, and it takes its dependencies as
# function arguments instead of reaching into an overlay.
#
# Before opening the pull request, fill in the hashes:
#   nix-prefetch-url --unpack \
#     https://github.com/exceptionptr/tsm-app-linux/archive/refs/tags/v1.1.16.tar.gz
#
# APScheduler 4 is still a pre-release, so nixpkgs has 3.x. The app uses the 4.x
# AsyncScheduler API, so either apscheduler_4 lands in nixpkgs first or this
# expression keeps the override below.
{
  lib,
  python3Packages,
  fetchFromGitHub,
  qt6,
}:

let
  apscheduler4 = python3Packages.buildPythonPackage rec {
    pname = "apscheduler";
    version = "4.0.0a6";
    pyproject = true;

    src = python3Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-UTRhfAKPCX3koJq77vxCYlywzjrctM5J10zCYFQIR2E=";
    };

    build-system = with python3Packages; [
      setuptools
      setuptools-scm
    ];

    dependencies = with python3Packages; [
      anyio
      attrs
      tenacity
      tzlocal
    ];

    doCheck = false; # needs live database and broker services
    pythonImportsCheck = [ "apscheduler" ];
  };
in
python3Packages.buildPythonApplication rec {
  pname = "tsm-app";
  version = "1.1.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "exceptionptr";
    repo = "tsm-app-linux";
    tag = "v${version}";
    hash = "sha256-/CPGY9s1gJpe+eWKioqM0Qp2IigPSp19fTjtxpIcm9I=";
  };

  # hatch-vcs takes the version from git tags, which a tarball does not carry.
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  build-system = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  dependencies = with python3Packages; [
    pyside6
    aiohttp
    pydantic
    aiosqlite
    keyring
    structlog
    tomli-w
    pyyaml
    typing-extensions
  ]
  ++ [ apscheduler4 ];

  # wrapQtAppsHook reads the plugin prefix off qtbase, and fails with
  # "qtPluginPrefix is unset" when it is not among the build inputs.
  buildInputs = [ qt6.qtbase ];
  nativeBuildInputs = [ qt6.wrapQtAppsHook ];
  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postInstall = ''
    install -Dm644 packaging/tsm-app.desktop \
      $out/share/applications/tsm-app.desktop
    for size in 16 32 48 128 256; do
      install -Dm644 "tsm/ui/assets/tsm_$size.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/tsm-app.png"
    done
  '';

  doCheck = false; # the widget tests need a display stack
  pythonImportsCheck = [ "tsm" ];

  meta = {
    description = "TradeSkillMaster auction data downloader for World of Warcraft on Linux";
    longDescription = ''
      Signs in to the TradeSkillMaster API, downloads auction house data for
      your realms, and writes the Lua files the TradeSkillMaster addon reads,
      for World of Warcraft running under Wine, Lutris, Proton or Steam.
    '';
    homepage = "https://github.com/exceptionptr/tsm-app-linux";
    changelog = "https://github.com/exceptionptr/tsm-app-linux/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "tsm-app";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ exceptionptr ];
  };
}
