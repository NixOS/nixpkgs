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
  version = "0-unstable-2025-12-30";

  src = fetchgit {
    url = "https://git.suckless.org/ubase";
    rev = "e8249b49ca3e02032dece5e0cdac3d236667a6d9";
    hash = "sha256-/XwDmhIBjISUyS1hBMcfBe5i4ISKj6sJTGb4lYfJqO0=";
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
