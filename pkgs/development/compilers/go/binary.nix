{
  lib,
  stdenv,
  fetchurl,
  version,
  hashes,
}:
let
  platform = with stdenv.hostPlatform.go; "${GOOS}-${if GOARCH == "arm" then "armv6l" else GOARCH}";
in
stdenv.mkDerivation {
  name = "go-${version}-${platform}-bootstrap";

  src = fetchurl {
    url = "https://go.dev/dl/go${version}.${platform}.tar.gz";
    sha256 = hashes.${platform} or (throw "Missing Go bootstrap hash for platform ${platform}");
  };

  # We must preserve the signature on Darwin
  dontStrip = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/go $out/bin
    cp -r . $out/share/go
    ln -s $out/share/go/bin/go $out/bin/go
    runHook postInstall
  '';

  meta = {
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    changelog = "https://go.dev/doc/devel/release#go${lib.versions.majorMinor version}";
    description = "The Go Programming language";
    homepage = "https://go.dev/";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.golang ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
}
