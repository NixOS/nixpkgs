{ stdenv, fetchurl, gtk-engine-murrine }:

let
  themeName = "Ant-Nebula";
in
stdenv.mkDerivation rec {
  pname = "ant-nebula-theme";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/EliverLara/${themeName}/releases/download/v${version}/${themeName}.tar";
    sha256 = "1xpgw577nmgjk547mg2vvv0gdai60srgncykm5pb1w8dnlk69jbz";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/themes/${themeName}
    cp -a * $out/share/themes/${themeName}
    rm -r $out/share/themes/${themeName}/{Art,LICENSE,README.md,gtk-2.0/render-assets.sh}
    runHook postInstall
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1lmlc4fvjnp05gshc0arfysh8r1xxzpzdv3j0bk40mjf3d59814c";

  meta = with stdenv.lib; {
    description = "Nebula variant of the Ant theme";
    homepage = "https://github.com/EliverLara/${themeName}";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ alexarice ];
  };
}
