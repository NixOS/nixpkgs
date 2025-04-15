{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "widevine-cdm";
  version = "4.10.2830.0";

  src = fetchzip {
    url = "https://dl.google.com/widevine-cdm/${finalAttrs.version}-linux-x64.zip";
    hash = "sha256-XDnsan1ulnIK87Owedb2s9XWLzk1K2viGGQe9LN/kcE=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -vD manifest.json $out/share/google/chrome/WidevineCdm/manifest.json
    install -vD LICENSE.txt $out/share/google/chrome/WidevineCdm/LICENSE.txt
    install -vD libwidevinecdm.so $out/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so

    runHook postInstall
  '';

  meta = import ./meta.nix lib;
})
