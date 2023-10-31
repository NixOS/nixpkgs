{ callPackage
, lib
, pkgs
}:

(callPackage ./changelog-d.nix { }).overrideAttrs (finalAttrs: oldAttrs: {

  version = oldAttrs.version + "-git-${lib.strings.substring 0 7 oldAttrs.src.rev}";

  passthru.updateScript = lib.getExe (pkgs.writeShellApplication {
    name = "update-changelog-d";
    runtimeInputs = [
      pkgs.cabal2nix
    ];
    text = ''
      cd pkgs/development/misc/haskell/changelog-d
      cabal2nix https://codeberg.org/fgaz/changelog-d >changelog-d.nix
    '';
  });
  passthru.tests = {
    basic = pkgs.runCommand "changelog-d-basic-test" {
        nativeBuildInputs = [ finalAttrs.finalPackage ];
      } ''
        mkdir changelogs
        cat > changelogs/config <<EOF
        organization: NixOS
        repository: boondoggle
        EOF
        cat > changelogs/a <<EOF
        synopsis: Support numbers with incrementing base-10 digits
        issues: #1234
        description: {
        This didn't work before.
        }
        EOF
        changelog-d changelogs >$out
        cat -n $out
        echo Checking the generated output
        set -x
        grep -F 'Support numbers with incrementing base-10 digits' $out >/dev/null
        grep -F 'https://github.com/NixOS/boondoggle/issues/1234' $out >/dev/null
        set +x
      '';
  };

  meta = oldAttrs.meta // {
    homepage = "https://codeberg.org/fgaz/changelog-d";
    maintainers = [ lib.maintainers.roberth ];
  };

})
