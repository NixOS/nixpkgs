{ stdenv, fetchFromGitHub, bash, which }:

stdenv.mkDerivation rec {
  version = "0.7.0";
  name = "nerdfonts-${version}";
  src = fetchFromGitHub {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = version;
    sha256 = "0q2h8hpkbid8idi2kvzx5bnhyh65y51k02g7xpv3drjqj08cz7y0";
  };
  dontPatchShebangs = true;
  buildInputs = [ which ];
  patchPhase = ''
    sed -i -e 's|/bin/bash|${bash}/bin/bash|g' install.sh
    sed -i -e 's|font_dir="\$HOME/.local|font_dir="$out|g' install.sh
  '';
  installPhase = ''
    mkdir -p $out/share/fonts
    ./install.sh
  '';
  meta = with stdenv.lib; {
    description = "Nerd Fonts is a project that attempts to patch as many developer targeted and/or used fonts as possible. The patch is to specifically add a high number of additional glyphs from popular 'iconic fonts' such as Font Awesome, Devicons, Octicons, and others.";
    homepage = "https://github.com/ryanoasis/nerd-fonts";
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
  };
}
