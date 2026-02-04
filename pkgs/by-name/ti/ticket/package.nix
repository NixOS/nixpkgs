{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  bash,
  coreutils,
  gnused,
  gawk,
  findutils,
  gnugrep,
  jq,
  ripgrep,
}:

stdenvNoCC.mkDerivation (final: {
  pname = "ticket";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "wedow";
    repo = "ticket";
    rev = "v${final.version}";
    hash = "sha256-orxqAwJBL+LHe+I9M+djYGa/yfvH67HdR/VVy8fdg90=";
  };

  nativeBuildInputs = [ makeWrapper ];

  patches = [ ./progname.patch ];

  postPatch = ''
    sed -i 's/^readonly PROGNAME=.*$/readonly PROGNAME=tk/' ticket
  '';

  dontBuild = true;

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    # Verify that tk prints "tk" as the program name, not ".tk-wrapped", based
    # on the local progname.patch that we apply.
    if ! $out/bin/tk --help 2>&1 | grep -q "^tk - minimal ticket system"; then
      echo "ERROR: tk --help does not show correct program name" 1>&2
      $out/bin/tk --help 1>&2 | head -5
      exit 1
    fi

    runHook postInstallCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ticket $out/bin/tk

    wrapProgram $out/bin/tk \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          gnused
          gawk
          findutils
          gnugrep
          jq
          ripgrep
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Git-backed issue tracker for AI agents";
    longDescription = ''
      The git-backed issue tracker for AI agents. Rooted in the Unix Philosophy,
      tk is a minimal ticket system with dependency tracking. Tickets are markdown
      files with YAML frontmatter in .tickets/.
    '';
    homepage = "https://github.com/wedow/ticket";
    changelog = "https://github.com/wedow/ticket/blob/v${final.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jmmv ];
    mainProgram = "tk";
    platforms = lib.platforms.unix;
  };
})
