{
  lib,
  stdenv,
  resholve,
  fetchFromGitHub,
  git,
  bash,
  openssl,
  gawk,
  /*
    TODO: yadm can use git-crypt and transcrypt
    but it does so in a way that resholve 0.6.0
    can't yet do anything smart about. It looks
    like these are for interactive use, so the
    main impact should just be that users still
    need both of these packages in their profile
    to support their use in yadm.
  */
  # git-crypt,
  # transcrypt,
  j2cli,
  esh,
  gnupg,
  coreutils,
  gnutar,
  installShellFiles,
  runCommand,
  yadm,

  # Templates:
  withAwk ? true,
  withEsh ? true,
  withJ2 ? true,

  # Encryption:
  withGpg ? true,
  withOpenssl ? true,
}:

let
  withTar = withGpg || withOpenssl;
in
resholve.mkDerivation rec {
  pname = "yadm";
  version = "3.5.0";

  nativeBuildInputs = [ installShellFiles ];

  src = fetchFromGitHub {
    owner = "yadm-dev";
    repo = "yadm";
    rev = version;
    hash = "sha256-hDo6zs70apNhKmuvR+eD51FzuTLj3SL/wHQXqLMD9QE=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin yadm
    runHook postInstall
  '';

  postInstall = ''
    installManPage yadm.1
    installShellCompletion --cmd yadm \
      --zsh completion/zsh/_yadm \
      --bash completion/bash/yadm
  '';

  solutions = {
    yadm = {
      scripts = [ "bin/yadm" ];
      interpreter = "${bash}/bin/sh";
      inputs = [
        bash
        coreutils
        git
        # see head comment
        # git-crypt
        # transcrypt
      ]
      ++ lib.optional withGpg gnupg
      ++ lib.optional withOpenssl openssl
      ++ lib.optional withAwk gawk
      ++ lib.optional withJ2 j2cli
      ++ lib.optional withEsh esh
      ++ lib.optional withTar gnutar;
      fake = {
        external = lib.optional (!stdenv.hostPlatform.isCygwin) "cygpath" ++ lib.optional (!withTar) "tar";
      };
      fix = {
        "$GIT_PROGRAM" = [ "git" ];
        "$GPG_PROGRAM" = lib.optional withGpg "gpg";
        "$OPENSSL_PROGRAM" = lib.optional withOpenssl "openssl";
        "$AWK_PROGRAM" = lib.optional withAwk "awk";
        # see head comment
        # "$GIT_CRYPT_PROGRAM" = [ "git-crypt" ];
        # "$TRANSCRYPT_PROGRAM" = [ "transcrypt" ];
        "$J2CLI_PROGRAM" = lib.optional withJ2 "j2";
        "$ESH_PROGRAM" = lib.optional withEsh "esh";
        # not in nixpkgs (yet)
        # "$ENVTPL_PROGRAM" = [ "envtpl" ];
        # "$LSB_RELEASE_PROGRAM" = [ "lsb_release" ];
      };
      keep = {
        "$YADM_COMMAND" = true; # internal cmds
        "$processor" = true; # dynamic, template-engine
        "$log" = true; # dynamic level-specific loggers
        "$SHELL" = true; # probably user env? unsure
        "$hook_command" = true; # ~git hooks?
        "exec" = [ "$YADM_BOOTSTRAP" ]; # yadm bootstrap script

        "$GPG_PROGRAM" = !withGpg;
        "$OPENSSL_PROGRAM" = !withOpenssl;
        "$AWK_PROGRAM" = !withAwk;
        "$J2CLI_PROGRAM" = !withJ2;
        "$ESH_PROGRAM" = !withEsh;

        # not in nixpkgs
        "$ENVTPL_PROGRAM" = true;
        "$LSB_RELEASE_PROGRAM" = true;
      };
      /*
        TODO: these should be dropped as fast as they can be dealt
              with properly in binlore and/or resholve.
      */
      execer = [
        "cannot:${j2cli}/bin/j2"
        "cannot:${esh}/bin/esh"
        "cannot:${git}/bin/git"
        "cannot:${gnupg}/bin/gpg"
      ];
    };
  };

  passthru.tests = {
    minimal = runCommand "${pname}-test" { } ''
      export HOME=$out
      ${yadm}/bin/yadm init
    '';
  };

  meta = {
    homepage = "https://github.com/yadm-dev/yadm";
    description = "Yet Another Dotfiles Manager";
    longDescription = ''
      yadm is a dotfile management tool with 3 main features:
      * Manages files across systems using a single Git repository.
      * Provides a way to use alternate files on a specific OS or host.
      * Supplies a method of encrypting confidential data so it can safely be stored in your repository.
    '';
    changelog = "https://github.com/yadm-dev/yadm/blob/${version}/CHANGES";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      abathur
      sandarukasa
    ];
    platforms = lib.platforms.unix;
    mainProgram = "yadm";
  };
}
