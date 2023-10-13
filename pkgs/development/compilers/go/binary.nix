{ lib, stdenv, makeGoPlatform, fetchurl, version, hashes, autoPatchelfHook }:
stdenv.mkDerivation (finalAttrs:
let
  goPlatform = makeGoPlatform { go = finalAttrs.finalPackage; };
  inherit (goPlatform.host.env) GOOS GOARCH;
  platform = "${GOOS}-${GOARCH}";
in
{
  name = "go-${version}-${platform}-bootstrap";

  src = fetchurl {
    url = "https://go.dev/dl/go${version}.${platform}.tar.gz";
    sha256 = hashes.${platform} or (throw "Missing Go bootstrap hash for platform ${platform}");
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  # We must preserve the signature on Darwin
  dontStrip = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/go $out/bin
    cp -r . $out/share/go
    ln -s $out/share/go/bin/go $out/bin/go
    runHook postInstall
  '';
})
