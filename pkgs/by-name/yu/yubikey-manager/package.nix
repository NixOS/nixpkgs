{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
  procps,
}:

python3Packages.buildPythonPackage rec {
  pname = "yubikey-manager";
  version = "5.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubikey-manager";
    tag = version;
    hash = "sha256-Z3krdKP6hhhIxN7nl/k5r30jFVC0kZK9Z6Aqllp/KrA=";
  };

  postPatch = ''
    substituteInPlace "ykman/pcsc/__init__.py" \
      --replace-fail 'pkill' '${if stdenv.hostPlatform.isLinux then procps else "/usr"}/bin/pkill'
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    cryptography
    pyscard
    fido2
    click
    keyring
  ];

  postInstall = ''
    installManPage man/ykman.1

    installShellCompletion --cmd ykman \
      --bash <(_YKMAN_COMPLETE=bash_source "$out/bin/ykman") \
      --zsh  <(_YKMAN_COMPLETE=zsh_source  "$out/bin/ykman") \
      --fish <(_YKMAN_COMPLETE=fish_source "$out/bin/ykman") \
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    makefun
  ];

  meta = {
    homepage = "https://developers.yubico.com/yubikey-manager";
    changelog = "https://github.com/Yubico/yubikey-manager/releases/tag/${src.tag}";
    description = "Command line tool for configuring any YubiKey over all USB transports";

    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      benley
      lassulus
      pinpox
      nickcao
    ];
    mainProgram = "ykman";
  };
}
