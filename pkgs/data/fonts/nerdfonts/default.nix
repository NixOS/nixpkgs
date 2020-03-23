{ lib, stdenv, fetchFromGitHub
, which, fonts ? []
, patchFontDrvs ? [], patchFlags ? [ "mono" "windows" "complete" "careful" ], fontforge ? null }:

assert patchFontDrvs != [] -> fontforge != null;

stdenv.mkDerivation rec {
  pname = "nerdfonts";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = version;
    sha256 = "1la79y16k9rwcl2zsxk73c0kgdms2ma43kpjfqnq5jlbfdj0niwg";
  };

  nativeBuildInputs = [ which fontforge ];

  patchPhase = ''
    patchShebangs install.sh
    sed -i -e 's|font_dir="\$HOME/.local/share/fonts|font_dir="$out/share/fonts/truetype|g' install.sh
  '';

  ffPatcher = "fontforge -script font-patcher ${lib.concatMapStringsSep " " (flag: "--${flag}") patchFlags}";

  installPhase = lib.concatMapStringsSep "\n" (drv: ''
    find ${drv.out}/share/fonts -name '*.otf' \
      -exec $ffPatcher --outputdir $out/share/fonts/opentype --extension otf "{}" \;
    find ${drv.out}/share/fonts -name '*.ttf' \
      -exec $ffPatcher --outputdir $out/share/fonts/truetype --extension ttf "{}" \;
  '') patchFontDrvs + lib.optionalString (fonts != null) ''
    ./install.sh ${lib.concatStringsSep " " fonts}

    mkdir -p $out/share/fonts/opentype
    find $out/share/fonts -name '*.otf' -exec mv "{}" $out/share/fonts/opentype \;
  '';

  meta = with lib; {
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
