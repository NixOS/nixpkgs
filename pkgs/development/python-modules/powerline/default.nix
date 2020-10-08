{ lib
, fetchFromGitHub
, python
, buildPythonPackage
, socat
, psutil
, hglib
, pygit2
, pyuv
, i3ipc
}:

# TODO: bzr support is missing because nixpkgs switched to `breezy`

buildPythonPackage rec {
  version  = "2.8.1";
  pname = "powerline";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0xscckcbw75pbcl4546ndrjs4682pn2sqqrd6qvqm0s6zswg7a0y";
  };

  propagatedBuildInputs = [
    socat
    psutil
    hglib
    pygit2
    pyuv
    i3ipc
  ];

  # tests are travis-specific
  doCheck = false;

  postInstall = ''
    install -dm755 "$out/share/fonts/OTF/"
    install -dm755 "$out/etc/fonts/conf.d"
    install -m644 "font/PowerlineSymbols.otf" "$out/share/fonts/OTF/PowerlineSymbols.otf"
    install -m644 "font/10-powerline-symbols.conf" "$out/etc/fonts/conf.d/10-powerline-symbols.conf"

    cp -ra powerline/bindings/{bash,fish,shell,tcsh,tmux,vim,zsh} $out/share/
    rm $out/share/*/*.py
  '';

  meta = {
    homepage    = "https://github.com/powerline/powerline";
    description = "The ultimate statusline/prompt utility";
    license     = lib.licenses.mit;
  };
}
