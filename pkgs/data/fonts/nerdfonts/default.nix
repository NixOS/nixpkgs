{ stdenv, fetchFromGitHub, which, withFont ? "" }:

stdenv.mkDerivation rec {
  version = "2.1.0";
  pname = "nerdfonts";
  src = fetchFromGitHub {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = version;
    sha256 = "1la79y16k9rwcl2zsxk73c0kgdms2ma43kpjfqnq5jlbfdj0niwg";
  };
  dontPatchShebangs = true;
  buildInputs = [ which ];
  patchPhase = ''
    patchShebangs install.sh
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
    maintainers = with maintainers; [ ];
    hydraPlatforms = []; # 'Output limit exceeded' on Hydra
  };
}
