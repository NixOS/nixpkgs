{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "fontconfig-ultimate-20141123";
  src = fetchurl {
    url = "https://github.com/bohoomil/fontconfig-ultimate/archive/2014-11-23.tar.gz";
    sha256 = "0czfm3hxc41x5mscwrba7p1vhm2w62j1qg7z8kfdrf21z8fvgznw";
  };

  phases = "$prePhases unpackPhase installPhase $postPhases";
  installPhase = ''
    mkdir -p $out/etc/fonts/conf.d
    cp conf.d.infinality/*.conf $out/etc/fonts/conf.d

    # Base rendering settings will be determined by NixOS module
    rm $out/etc/fonts/conf.d/10-base-rendering.conf

    # Options controlled by NixOS module
    rm $out/etc/fonts/conf.d/35-repl-custom.conf
    rm $out/etc/fonts/conf.d/38-repl-*.conf
    rm $out/etc/fonts/conf.d/82-*.conf
    rm $out/etc/fonts/conf.d/83-*.conf

    # Inclusion of local and user configs handled by global configuration
    rm $out/etc/fonts/conf.d/97-local.conf
    rm $out/etc/fonts/conf.d/98-user.conf

    cp fontconfig_patches/fonts-settings/*.conf $out/etc/fonts/conf.d

    mkdir -p $out/etc/fonts/presets/{combi,free,ms}
    cp fontconfig_patches/combi/*.conf $out/etc/fonts/presets/combi
    cp fontconfig_patches/free/*.conf $out/etc/fonts/presets/free
    cp fontconfig_patches/ms/*.conf $out/etc/fonts/presets/ms
  '';
}
