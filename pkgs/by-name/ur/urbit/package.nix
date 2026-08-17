{
  stdenv,
  lib,
  fetchurl,
}:

let
  os = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
  platform = "${os}-${arch}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "urbit";
  version = "4.5";

  src = fetchurl {
    url = "https://github.com/urbit/vere/releases/download/vere-v${finalAttrs.version}/${platform}.tgz";
    sha256 =
      {
        x86_64-linux = "1vbyh6glh4fqcx8d8x2jp88nzl9922dj709zgwhvy858s2m30ymz";
        aarch64-linux = "18gc1kyxj4j6vikxpif4a1b6l629m0lnhdzmlwx5i2v0l18drvbp";
        x86_64-darwin = "02g431xgjw8gwa823kkxnzhg1cgswi3nlkv54mzkjxbhw856qa4z";
        aarch64-darwin = "06x8mdxmbmhg78jzsf0n83cwmp2czp74ssh616ikqf1r8v5l0h2p";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  unpackPhase = ''
    mkdir src
    tar -C src -xf $src
  '';

  postInstall = ''
    install -m755 -D src/vere-v${finalAttrs.version}-${platform} $out/bin/urbit
  '';

  passthru.updateScript = ./update-bin.sh;

  meta = {
    homepage = "https://urbit.org";
    description = "Operating function";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ lib.maintainers.matthew-levan ];
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "urbit";
  };
})
