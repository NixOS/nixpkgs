{ stdenv, fetchFromGitHub }:

let version = "2016-04-23"; in
stdenv.mkDerivation {
  name = "fontconfig-ultimate-${version}";

  src = fetchFromGitHub {
    sha256 = "1rd2n60l8bamx84q3l91pd9a0wz9h7p6ajvx1dw22qn8rah4h498";
    rev = version;
    repo = "fontconfig-ultimate";
    owner = "bohoomil";
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
    rm $out/etc/fonts/conf.d/29-local.conf
    rm $out/etc/fonts/conf.d/28-user.conf

    cp fontconfig_patches/fonts-settings/*.conf $out/etc/fonts/conf.d

    # fix font priority issue https://github.com/bohoomil/fontconfig-ultimate/issues/173
    mv $out/etc/fonts/conf.d/{43,60}-wqy-zenhei-sharp.conf

    mkdir -p $out/etc/fonts/presets/{combi,free,ms}
    cp fontconfig_patches/combi/*.conf $out/etc/fonts/presets/combi
    cp fontconfig_patches/free/*.conf $out/etc/fonts/presets/free
    cp fontconfig_patches/ms/*.conf $out/etc/fonts/presets/ms
  '';
}
