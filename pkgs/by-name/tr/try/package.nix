{
  stdenv,
  autoreconfHook,
  lib,
  fetchFromGitHub,
  util-linux,
  mergerfs,
  attr,
  makeWrapper,
  pandoc,
  kmod,
  installShellFiles,
  versionCheckHook,
}:
stdenv.mkDerivation {
  pname = "try";
  version = "0.2.0-unstable-2025-02-25";
  src = fetchFromGitHub {
    owner = "binpash";
    repo = "try";
    rev = "67052d8f20725f3cdc22ffaec33f7b7c14f1eb6b";
    hash = "sha256-8mfCmqN50pRAeNTJUlRVrRQulWon4b2OL4Ug/ygBhB0=";
  };
  nativeBuildInputs = [
    makeWrapper
    autoreconfHook
    pandoc
    attr
    util-linux
    kmod
    installShellFiles
  ];
  # Trigger a overlay run to load the overlayfs module, required by ./configure
  preConfigure = ''
    mkdir lower upper work merged
    unshare -r --mount mount -t overlay overlay -o lowerdir=lower,upperdir=upper,workdir=work merged
    rm -rf lower upper work merged
  '';
  installPhase = ''
    runHook preInstall
    install -Dt $out/bin try
    install -Dt $out/bin utils/try-commit
    install -Dt $out/bin utils/try-summary
    wrapProgram $out/bin/try --prefix PATH : ${
      lib.makeBinPath [
        util-linux
        mergerfs
        attr
      ]
    }
    installManPage man/try.1.gz
    installShellCompletion --bash --name try.bash completions/try.bash
    runHook postInstall
  '';
  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  preVersionCheck = ''
    export version=0.2.0
  '';
  versionCheckProgramArg = "-v";
  meta = with lib; {
    homepage = "https://github.com/binpash/try";
    description = "Lets you run a command and inspect its effects before changing your live system";
    mainProgram = "try";
    maintainers = with maintainers; [
      pasqui23
      ezrizhu
    ];
    license = with licenses; [ mit ];
    platforms = platforms.linux;
  };
}
