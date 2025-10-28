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
    description = "Go Programming language";
    homepage = "https://go.dev/";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.golang ];
    platforms = lib.platforms.darwin ++ lib.platforms.freebsd ++ lib.platforms.linux;
    badPlatforms = [
      # Support for big-endian POWER < 8 was dropped in 1.9, but POWER8 users have less of a reason to run in big-endian mode than pre-POWER8 ones
      # So non-LE ppc64 is effectively unsupported, and Go SIGILLs on affordable ppc64 hardware
      # https://github.com/golang/go/issues/19074 - Dropped support for big-endian POWER < 8, with community pushback
      # https://github.com/golang/go/issues/73349 - upstream will not accept submissions to fix this
      "powerpc64-linux"
    ];
  };
}
