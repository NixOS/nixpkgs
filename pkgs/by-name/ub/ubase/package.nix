{
  lib,
  stdenv,
  fetchgit,
  libxcrypt,
  testers,
  unstableGitUpdater,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ubase";
  version = "0-unstable-2024-03-07";

  src = fetchgit {
    url = "https://git.suckless.org/ubase";
    rev = "a570a80ed1606bed43118cb148fc83c3ac22b5c1";
    hash = "sha256-afsTkctATIZ6ug9S2gIGoxtFM1h/esgsexyuxXpocs0=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  buildInputs = [ libxcrypt ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  buildFlags = [ "ubase-box" ];
  installTargets = [ "ubase-box-install" ];

  passthru = {
    updateScript = unstableGitUpdater { };

    tests = {
      ddCopiesBytes = testers.runCommand {
        name = "ubase-dd-copies-bytes";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          dd if=/dev/zero of=test.bin bs=1 count=4
          set -- $(stat -t test.bin)
          [ "$1" = "test.bin" ] && [ "$2" = "4" ]
          touch $out
        '';
      };

      idMatchesUid = testers.runCommand {
        name = "ubase-id-matches-uid";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          [ "$(id -u)" = "$UID" ]
          touch $out
        '';
      };

      pagesizePositive = testers.runCommand {
        name = "ubase-pagesize-positive";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          [ "$(pagesize)" -gt 0 ]
          touch $out
        '';
      };

      whichIdIsBox = testers.runCommand {
        name = "ubase-which-id-is-box";
        buildInputs = [
          which
          finalAttrs.finalPackage
        ];
        script = ''
          [ $(which id) -ef $(which ubase-box) ]
          touch $out
        '';
      };
    };
  };

  meta = {
    description = "Linux base utilities from suckless.org";
    homepage = "https://core.suckless.org/ubase/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "ubase-box";
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
