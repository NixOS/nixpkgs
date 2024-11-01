{ lib, stdenv, fetchurl, version, hashes }:
let
  toGoKernel = platform:
    if platform.isDarwin then "darwin"
    else platform.parsed.kernel.name;

  toGoCPU = platform: {
    "i686" = "386";
    "x86_64" = "amd64";
    "aarch64" = "arm64";
    "armv6l" = "armv6l";
    "armv7l" = "armv6l";
    "powerpc64le" = "ppc64le";
    "riscv64" = "riscv64";
  }.${platform.parsed.cpu.name} or (throw "Unsupported CPU ${platform.parsed.cpu.name}");

  toGoPlatform = platform: "${toGoKernel platform}-${toGoCPU platform}";

  platform = toGoPlatform stdenv.hostPlatform;
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
    maintainers = lib.teams.golang.members;
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
}
