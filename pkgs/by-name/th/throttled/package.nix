{
  lib,
  fetchFromGitHub,
  python3Packages,
  pciutils,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "throttled";
  version = "0.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erpalma";
    repo = "throttled";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hwnJO9KEDOizpGcb9NYHYHoEEHKa3PkLt76cKpwgEUs=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    configparser
    dbus-fast
  ];

  # The upstream unit assumes the /opt/throttled venv install location
  postPatch = ''
    substituteInPlace systemd/throttled.service \
      --replace-fail '/opt/throttled/venv/bin/throttled' \
      '${placeholder "out"}/bin/throttled'

    substituteInPlace throttled.py --replace-fail "'setpci'" "'${lib.getExe' pciutils "setpci"}'"
  '';

  postInstall = ''
    install -D -m644 -t $out/etc etc/*
    install -D -m644 -t $out/lib/systemd/system systemd/*
  '';

  pythonImportsCheck = [ "throttled" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Fix for Intel CPU throttling issues";
    homepage = "https://github.com/erpalma/throttled";
    changelog = "https://github.com/erpalma/throttled/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "throttled";
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
})
