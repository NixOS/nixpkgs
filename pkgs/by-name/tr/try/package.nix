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
  coreutils,
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

  # skip TRY_REQUIRE_PROG as it detects executable dependencies by running it
  postPatch = ''
    sed -i '/^AC_DEFUN(\[TRY_REQUIRE_PROG\]/,/^])$/c\AC_DEFUN([TRY_REQUIRE_PROG], [])' configure.ac
  '';

  nativeBuildInputs = [
    makeWrapper
    autoreconfHook
    pandoc
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin try
    install -Dt $out/bin utils/try-commit
    install -Dt $out/bin utils/try-summary
    wrapProgram $out/bin/try --prefix PATH : ${
      lib.makeBinPath [
        coreutils
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

  meta = {
    homepage = "https://github.com/binpash/try";
    description = "Lets you run a command and inspect its effects before changing your live system";
    mainProgram = "try";
    maintainers = with lib.maintainers; [
      pasqui23
      ezrizhu
    ];
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.linux;
  };
}
