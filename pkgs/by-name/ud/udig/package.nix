{
  stdenv,
  lib,
  fetchurl,
  unzip,
  makeWrapper,
  jre8,
  libXtst,
  gdal,
}:
let
  pname = "udig";
  version = "2.0.0";

  srcs = {
    x86_64-linux = fetchurl {
      url = "http://udig.refractions.net/files/downloads/udig-${version}.linux.gtk.x86_64.zip";
      hash = "sha256-ijuSWq1jSsB8K653bjcUdNwVGZscDaTuegBr01oNEg4=";
    };
    x86_64-darwin = fetchurl {
      url = "http://udig.refractions.net/files/downloads/udig-${version}.macosx.cocoa.x86_64.zip";
      hash = "sha256-Ihk3InHB3/tEYRqH2ozhokz2GN8Gfig5DJkO/8P1LJs=";
    };
  };
  src =
    srcs.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");

  meta = with lib; {
    description = "User-friendly Desktop Internet GIS";
    homepage = "http://udig.refractions.net/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = with licenses; [
      epl10
      bsd3
    ];
    maintainers = with maintainers; [ sikmir ];
    platforms = builtins.attrNames srcs;
    mainProgram = "udig";
  };

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [
      unzip
      makeWrapper
    ];

    installPhase = ''
      install -dm755 $out/bin $out/opt/udig
      cp -r . $out/opt/udig
      makeWrapper $out/opt/udig/udig.sh $out/bin/udig \
        --prefix PATH : ${jre8}/bin \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            libXtst
            gdal
          ]
        }
    '';

    postFixup = ''
      patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        $out/opt/udig/udig_internal
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [
      unzip
      makeWrapper
    ];

    postPatch = ''
      substituteInPlace configuration/config.ini \
        --replace "\$LOCALAPPDATA\$" "@user.home"
    '';

    installPhase = ''
      mkdir -p $out/Applications/udig
      cp -R . $out/Applications/udig
      wrapProgram $out/Applications/udig/udig.app/Contents/MacOS/udig_internal \
        --prefix DYLD_LIBRARY_PATH : ${lib.makeLibraryPath [ gdal ]}
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
