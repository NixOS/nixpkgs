{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
    pname = "cyberpunk-neon";
    version = "b4b293c";

    src = fetchFromGitHub {
        owner = "Roboron3042";
        repo = "Cyberpunk-Neon";
        rev = version;
        sha256 = "sha256-yqr4xga4hzd+BJpEECPK0xQDP3CjABfJISQS684SbwM=";
    };

    dontBuild = true;

    installPhase = ''
        # gtk
        mkdir -p $out/share/themes
        tar xzf gtk/materia-cyberpunk-neon.tar.gz -C $out/share/themes/
        tar xzf gtk/arc-cyberpunk-neon.tar.gz -C $out/share/themes/
        
        # kde
        mkdir -p $out/share/color-schemes
        cp kde/cyberpunk-neon.colors $out/share/color-schemes/
        # terminal
        mkdir -p $out/share/konsole
        cp terminal/konsole/cyberpunk-neon.colorscheme $out/share/konsole
        mkdir -p $out/share/tilix/schemes
        cp terminal/tilix/cyberpunk-neon.json $out/share/tilix/schemes
    '';

    meta = with stdenv.lib; {
        description = "Theme for GTK, plasma, konsole and tilix ";
        license = licenses.cc-by-sa-40;
        platforms = platforms.unix;
        maintainers = [ maintainers.rpgwaiter ];
    };
}