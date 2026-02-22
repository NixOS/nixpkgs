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
  version = "4.2";

  src = fetchurl {
    url = "https://github.com/urbit/vere/releases/download/vere-v${finalAttrs.version}/${platform}.tgz";
    sha256 =
      {
        x86_64-linux = "0cmgm0cjcj0089dd7dnncl5lhw6ji669byjbzd72va51abdirnkq";
        aarch64-linux = "1il2khylsxj3k757f401ph5g1sx6f4y85p87bzwgaksdb4nkq6mi";
        x86_64-darwin = "1p09y7c81m3mx9cm0689jbg1daz0xpr2p2bzqfnnlgzjlmi9x794";
        aarch64-darwin = "1gy64mhvk8450mv2abjc62c2sh0b1criiwrdmyj8kyfv4qpiqyc8";
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
