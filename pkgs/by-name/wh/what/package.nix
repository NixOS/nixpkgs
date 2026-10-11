{
  lib,
  darwin,
  stdenv,
}:

# Building all of shell_cmds on non-Darwin platforms is too much work, but `what` may be useful.
# In particular, it’s (theoretically) needed by Swift Build.
stdenv.mkDerivation (
  {
    pname = "what";
    version = lib.getVersion darwin.shell_cmds;

    outputs = [
      "out"
      "man"
    ];

    strictDeps = true;
    __structuredAttrs = true;

    meta = {
      description = "Show what versions were used to construct an object file";
      platforms = lib.platforms.unix;
      inherit (darwin.shell_cmds.meta) homepage license teams;
    };
  }
  // (
    if stdenv.hostPlatform.isDarwin then
      {
        buildCommand = ''
          mkdir -p "$out/bin" "$man/share/man/man1"
          ln -s ${lib.getExe' darwin.shell_cmds "what"} "$out/bin/what"
          ln -s ${lib.getMan darwin.shell_cmds}/share/man/man1/what.1.gz "$man/share/man/man1/what.1.gz"
        '';
      }
    else
      {
        inherit (darwin.shell_cmds) src;

        configurePhase = ''
          runHook preConfigure
          mkdir build
          runHook postConfigure
        '';

        buildPhase = ''
          runHook preBuild
          $CC -O3 -D__FBSDID\(n\)= what/what.c -o build/what
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          install -m755 -D build/what "$out/bin/what"
          install -m755 -D what/what.1 "$man/share/man/man1/what.1"
          runHook postInstall
        '';
      }
  )
)
