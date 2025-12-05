{
  lib,
  stdenv,
  fetchurl,
  go-crx3,
}:

let
  manifest = builtins.fromJSON (builtins.readFile ./x86_64-manifest.json);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "widevine-cdm";
  version = manifest.version;

  src = fetchurl {
    url = manifest.url;
    hash = manifest.sri;
  };

  nativeBuildInputs = [ go-crx3 ];

  unpackPhase = ''
    unpackDir="src"
    cp "$src" "$unpackDir".crx # go-crx3 doesn't like .crx3 extensions
    crx3 unpack "$unpackDir".crx

    cd "$unpackDir"
  '';

  installPhase = ''
    runHook preInstall

    install -vD manifest.json $out/share/google/chrome/WidevineCdm/manifest.json
    install -vD LICENSE $out/share/google/chrome/WidevineCdm/LICENSE.txt
    install -vD _platform_specific/linux_x64/libwidevinecdm.so $out/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so

    runHook postInstall
  '';

  passthru.updateScript = ./update-x86_64.py;

  meta = import ./meta.nix lib;
})
