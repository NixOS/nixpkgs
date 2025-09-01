{
  stdenv,
  lib,
  fetchurl,
  unzip,
}:
let
  sources = lib.importJSON ./sources.json;
  platform =
    if (builtins.hasAttr stdenv.hostPlatform.system sources.platforms) then
      builtins.getAttr (stdenv.hostPlatform.system) sources.platforms
    else
      throw "Not supported on ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation {
  pname = "tabnine";
  inherit (sources) version;

  src = fetchurl {
    url = "https://update.tabnine.com/bundles/${sources.version}/${platform.name}/TabNine.zip";
    inherit (platform) hash;
  };

  dontBuild = true;

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    install -Dm755 TabNine $out/bin/TabNine
    install -Dm755 TabNine-deep-cloud $out/bin/TabNine-deep-cloud
    install -Dm755 TabNine-deep-local $out/bin/TabNine-deep-local
    install -Dm755 WD-TabNine $out/bin/WD-TabNine
    runHook postInstall
  '';

  passthru = {
    platform = platform.name;
    updateScript = ./update.sh;
  };

  meta = with lib; {
    homepage = "https://tabnine.com";
    description = "Smart Compose for code that uses deep learning to help you write code faster";
    license = licenses.unfree;
    platforms = attrNames sources.platforms;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
