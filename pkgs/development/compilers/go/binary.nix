{
  lib,
  stdenv,
  fetchurl,
  version,
  hashes,
}:
let
  inherit (stdenv.hostPlatform.go.env) GOOS GOARCH;

  # ARM releases are for "armv6l", but all platforms except for Linux use "arm"
  # in the file name.
  # TODO: we should be using "filename" field from JSON.
  inherit (stdenv.hostPlatform) isAarch32 isLinux;
  isArmv5 = isAarch32 && lib.versionOlder stdenv.hostPlatform.parsed.cpu.version "6";
  distArch = if isAarch32 then "armv6l" else GOARCH;
  fileArch = if isLinux && isAarch32 then "armv6l" else GOARCH;
in
stdenv.mkDerivation {
  name = "go-${version}-${GOOS}-${GOARCH}-bootstrap";

  src = fetchurl {
    url = "https://go.dev/dl/go${version}.${GOOS}-${fileArch}.tar.gz";
    sha256 =
      hashes.${"${GOOS}-${distArch}"}
        or (throw "Missing Go bootstrap hash for platform ${stdenv.hostPlatform.config}");
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
    maintainers = lib.teams.golang.members;
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    broken = isArmv5;
  };
}
