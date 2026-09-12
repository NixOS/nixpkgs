{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  pciutils,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "throttled";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "erpalma";
    repo = "throttled";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hwnJO9KEDOizpGcb9NYHYHoEEHKa3PkLt76cKpwgEUs=";
  };

  nativeBuildInputs = [ python3Packages.wrapPython ];

  pythonPath = [ python3Packages.dbus-fast ];

  # The upstream unit assumes the /opt/throttled venv install location
  postPatch = ''
    substituteInPlace systemd/throttled.service \
      --replace-fail '/opt/throttled/venv/bin/throttled' \
      '${placeholder "out"}/bin/throttled.py'

    substituteInPlace throttled.py --replace-fail "'setpci'" "'${lib.getExe' pciutils "setpci"}'"
  '';

  installPhase = ''
    runHook preInstall

    install -D -m755 -t $out/bin throttled.py
    install -D -m644 -t $out/bin mmio.py throttled_version.py
    install -D -m644 -t $out/etc etc/*
    install -D -m644 -t $out/lib/systemd/system systemd/*

    runHook postInstall
  '';

  postFixup = "wrapPythonPrograms";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  # the check run imports mmio/throttled_version next to the script; keep it
  # from littering $out/bin with __pycache__ (the hook strips the environment)
  env.PYTHONDONTWRITEBYTECODE = "1";
  versionCheckKeepEnvironment = "PYTHONDONTWRITEBYTECODE";

  meta = {
    description = "Fix for Intel CPU throttling issues";
    homepage = "https://github.com/erpalma/throttled";
    changelog = "https://github.com/erpalma/throttled/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "throttled.py";
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
})
