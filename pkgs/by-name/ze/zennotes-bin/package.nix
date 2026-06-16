{
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
  electron_41,
  lib,
}:
let
  electron = electron_41;
in
stdenv.mkDerivation rec {
  pname = "ZenNotes";
  version = "2.3.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/ZenNotes/zennotes/releases/download/v${version}/ZenNotes-${version}-linux-x86_64.AppImage";
    sha256 = "sha256-IvFGK7n3KQVGETmt6hQUy+bZNTOCkfuwH8ifl4KTxxw=";
    name = "${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname;
    inherit version;
    inherit src;
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications

    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/ZenNotes.desktop $out/share/applications/${pname}.desktop
    cp -a ${appimageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = {
    description = "ZenNotes is a keyboard-first Markdown notes app with a shared product core and multiple runtimes";
    homepage = "https://github.com/ZenNotes/zennotes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wetrustinprize ];
    platforms = [ "x86_64-linux" ];
  };
}
