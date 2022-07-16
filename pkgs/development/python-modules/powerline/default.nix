{ lib
, fetchFromGitHub
, buildPythonPackage
, socat
, psutil
, hglib
, pygit2
, pyuv
, i3ipc
, stdenv
}:

# TODO: bzr support is missing because nixpkgs switched to `breezy`

buildPythonPackage rec {
  version  = "2.8.3";
  pname = "powerline";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-UIx9/IZg6Wv596wHzQb0CO6zwmQXUaFEPKBojo2LXmA=";
  };

  propagatedBuildInputs = [
    socat
    psutil
    hglib
    pygit2
    pyuv
  ] ++ lib.optionals (!stdenv.isDarwin) [ i3ipc ];

  # tests are travis-specific
  doCheck = false;

  postInstall = ''
    install -dm755 "$out/share/fonts/OTF/"
    install -dm755 "$out/etc/fonts/conf.d"
    install -m644 "font/PowerlineSymbols.otf" "$out/share/fonts/OTF/PowerlineSymbols.otf"
    install -m644 "font/10-powerline-symbols.conf" "$out/etc/fonts/conf.d/10-powerline-symbols.conf"

    install -dm755 "$out/share/fish/vendor_functions.d"
    install -m644 "powerline/bindings/fish/powerline-setup.fish" "$out/share/fish/vendor_functions.d/powerline-setup.fish"

    cp -ra powerline/bindings/{bash,shell,tcsh,tmux,vim,zsh} $out/share/
    rm $out/share/*/*.py
  '';

  meta = {
    homepage    = "https://github.com/powerline/powerline";
    description = "The ultimate statusline/prompt utility";
    license     = lib.licenses.mit;
  };
}
