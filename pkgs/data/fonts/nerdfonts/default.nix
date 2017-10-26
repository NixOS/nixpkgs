{ stdenv, fetchFromGitHub, bash, which, withFont ? "" }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "nerdfonts-${version}";
  src = fetchFromGitHub {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = version;
    sha256 = "0h12d33wnhs5w8r3h1gqil98442vf7a13ms3nwldsam4naapsqxz";
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
    description = ''
      Nerd Fonts is a project that attempts to patch as many developer targeted
      and/or used fonts as possible. The patch is to specifically add a high
      number of additional glyphs from popular 'iconic fonts' such as Font
      Awesome, Devicons, Octicons, and others.
    '';
    homepage = https://github.com/ryanoasis/nerd-fonts;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
    platforms = with platforms; unix;
    hydraPlatforms = []; # 'Output limit exceeded' on Hydra
  };
}
