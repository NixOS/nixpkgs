{ stdenv, fetchFromGitHub, bash, which, withFont ? "" }:

stdenv.mkDerivation rec {
  version = "0.8.0";
  name = "nerdfonts-${version}";
  src = fetchFromGitHub {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = version;
    sha256 = "0n7idfk4460j8g0rw73hzz195pdh4c916hpc5r6dxpvgcmvryzc5";
  };
  dontPatchShebangs = true;
  buildInputs = [ which ];
  patchPhase = ''
    sed -i -e 's|/bin/bash|${bash}/bin/bash|g' install.sh
    sed -i -e 's|font_dir="\$HOME/.local/share/fonts|font_dir="$out/share/fonts/truetype|g' install.sh
  '';
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    ./install.sh ${withFont}
  '';
  meta = with stdenv.lib; {
    description = "Nerd Fonts is a project that attempts to patch as many developer targeted and/or used fonts as possible. The patch is to specifically add a high number of additional glyphs from popular 'iconic fonts' such as Font Awesome, Devicons, Octicons, and others.";
    homepage = "https://github.com/ryanoasis/nerd-fonts";
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
    platforms = with platforms; unix;
  };
}
