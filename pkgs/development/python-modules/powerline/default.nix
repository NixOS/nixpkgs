{ lib
, fetchurl
, buildPythonPackage
, psutil
, pygit2
}:

# The source of this package needs to be patched to include the full path to
# the executables of git, mercurial and bazaar.

buildPythonPackage rec {
  version  = "2.6";
  pname = "powerline";
  name = pname + "-" + version;

  src = fetchurl {
    url    = "https://github.com/powerline/powerline/archive/${version}.tar.gz";
    name   = "${name}.tar.gz";
    sha256 = "c108f11fe10dc910febb94b87d3abded85d4363fb950366a9e30282b9ba7c272";
  };

  propagatedBuildInputs = [ psutil pygit2];

# error: This is still beta and some tests still fail
  doCheck = false;

  postInstall = ''
    install -dm755 "$out/share/fonts/OTF/"
    install -dm755 "$out/etc/fonts/conf.d"
    install -m644 "font/PowerlineSymbols.otf" "$out/share/fonts/OTF/PowerlineSymbols.otf"
    install -m644 "font/10-powerline-symbols.conf" "$out/etc/fonts/conf.d/10-powerline-symbols.conf"

    install -dm755 "$out/share/vim/vimfiles/plugin"
    install -m644 "powerline/bindings/vim/plugin/powerline.vim" "$out/share/vim/vimfiles/plugin/powerline.vim"

    install -dm755 "$out/share/zsh/site-contrib"
    install -m644 "powerline/bindings/zsh/powerline.zsh" "$out/share/zsh/site-contrib/powerline.zsh"

    install -dm755 "$out/share/tmux"
    install -m644 "powerline/bindings/tmux/powerline.conf" "$out/share/tmux/powerline.conf"
    '';

  meta = {
    homepage    = https://github.com/powerline/powerline;
    description = "The ultimate statusline/prompt utility";
    license     = lib.licenses.mit;
  };
}
