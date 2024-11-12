{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  socat,
  psutil,
  python-hglib,
  pygit2,
  pyuv,
  i3ipc,
  stdenv,
}:

# TODO: bzr support is missing because nixpkgs switched to `breezy`

buildPythonPackage rec {
  version = "2.8.4";
  pname = "powerline";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-snJrfUvP11lBIy6F0WtqJt9fiYm5jxMwm9u3u5XFO84=";
  };

  propagatedBuildInputs = [
    socat
    psutil
    python-hglib
    pygit2
    pyuv
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ i3ipc ];

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
    homepage = "https://github.com/powerline/powerline";
    description = "Ultimate statusline/prompt utility";
    license = lib.licenses.mit;
  };
}
