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
  lib,
  haskellPackages,
  fetchFromGitHub,
  python3,
  git,
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
    version = "0.6";
    src = fetchFromGitHub {
      owner = "zsh-git-prompt";
      repo = "zsh-git-prompt";
      tag = "v${version}";
      hash = "sha256-F9tREogSVMfIcu0cFpWzF187C9pkVX+7jMVXI+uj28A=";
    };
    prePatch = ''
      substituteInPlace zshrc.sh \
        --replace-fail ':-"python"' ':-"haskell"' \
        --replace-fail 'git ' '${git}/bin/git '
    '';
    preCompileBuildDriver = "cd haskell";
    postInstall = ''
      cd ..
      gpshare=$out/share/zsh-git-prompt
      gpdoc=$out/share/doc/zsh-git-prompt
      mkdir -p $gpshare/src $gpdoc
      cp README.md $gpdoc
      substituteInPlace zshrc.sh \
        --replace-fail "#!/bin/zsh" ""
      cp zshrc.sh python/gitstatus.py $gpshare
      mv $out/bin $gpshare/src/.bin
    '';
    # upstream is not updated
    doCheck = false;
    isLibrary = false;
    isExecutable = true;
    libraryHaskellDepends = [
      base
      parsec
      process
      QuickCheck
      python3
    ];
    executableHaskellDepends = libraryHaskellDepends;
    testHaskellDepends = [ HUnit ] ++ libraryHaskellDepends;
    homepage = "https://github.com/zsh-git-prompt/zsh-git-prompt";
    description = "Informative git prompt for zsh";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.league ];
  }
) { }
