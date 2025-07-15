{
  stdenv,
  lib,
  fetchzip,
}:

let
  os = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
  platform = "${os}-${arch}";
in
stdenv.mkDerivation rec {
  pname = "urbit";
  version = "3.4";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 =
      {
        x86_64-linux = "sha256-BflhL1T33VqWW9ni9TZuNAauPh0d8hRhkdUgZPGXW+Q=";
        aarch64-linux = "sha256-NJS7s3bXu072m3bbfpKj8CyB2qLa9v/rkUCDBoY+2vs=";
        x86_64-darwin = "sha256-qivzosca6zq2Rmv4hqwQi5Mmm/HWJS8tEosArlzcU3M=";
        aarch64-darwin = "sha256-RBM44+Govt5MidSBWODi/62RdOxd8KVFNQJGbvA4yNw=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  postInstall = ''
    install -m755 -D vere-v${version}-${platform} $out/bin/urbit
  '';

  passthru.updateScript = ./update-bin.sh;

  meta = with lib; {
    homepage = "https://urbit.org";
    description = "Operating function";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ maintainers.matthew-levan ];
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "urbit";
  };
}
