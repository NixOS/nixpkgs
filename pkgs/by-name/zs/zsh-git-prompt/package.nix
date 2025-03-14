# zsh-git-prompt -- Informative git prompt for zsh
#
# Usage: to enable this plugin for all users, you could
# add it to configuration.nix like this:
#
#   programs.zsh.interactiveShellInit = ''
#     source ${pkgs.zsh-git-prompt}/share/zsh-git-prompt/zshrc.sh
#   '';
#
# Or you can install it globally but only enable it in individual
# users' ~/.zshrc files:
#
#   source /run/current-system/sw/share/zsh-git-prompt/zshrc.sh
#
# Or if installed locally:
#
#   source ~/.nix-profile/share/zsh-git-prompt/zshrc.sh
#
# Either way, you then have to set a prompt that incorporates
# git_super_status, for example:
#
#   PROMPT='%B%m%~%b$(git_super_status) %# '
#
# More details are in share/doc/zsh-git-prompt/README.md, once
# installed.
#
{
  fetchFromGitHub,
  python3,
  git,
  lib,
  haskellPackages,
}:

haskellPackages.callPackage (
  {
    mkDerivation,
    base,
    HUnit,
    parsec,
    process,
    QuickCheck,
  }:
  mkDerivation rec {
    pname = "zsh-git-prompt";
    version = "0.4z"; # While we await a real 0.5 release.
    src = fetchFromGitHub {
      owner = "starcraftman";
      repo = "zsh-git-prompt";
      rev = "11b83ba3b85d14c66cf2ab79faefab6d838da28e";
      sha256 = "04aylsjfb03ckw219plkzpyiq4j9g66bjxa5pa56h1p7df6pjssb";
    };
    prePatch = ''
      substituteInPlace zshrc.sh                       \
        --replace ':-"python"' ':-"haskell"'           \
        --replace 'python '    '${python3.interpreter} ' \
        --replace 'git '       '${git}/bin/git '
    '';
    preCompileBuildDriver = "cd src";
    postInstall = ''
      cd ..
      gpshare=$out/share/${pname}
      gpdoc=$out/share/doc/${pname}
      mkdir -p $gpshare/src $gpdoc
      cp README.md $gpdoc
      cp zshrc.sh gitstatus.py $gpshare
      mv $out/bin $gpshare/src/.bin
    '';
    isLibrary = false;
    isExecutable = true;
    libraryHaskellDepends = [
      base
      parsec
      process
      QuickCheck
    ];
    executableHaskellDepends = libraryHaskellDepends;
    testHaskellDepends = [ HUnit ] ++ libraryHaskellDepends;
    homepage = "https://github.com/olivierverdier/zsh-git-prompt#readme";
    description = "Informative git prompt for zsh";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.league ];
  }
) { }
