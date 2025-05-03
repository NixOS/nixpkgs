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
  version = "3.2";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 =
      {
        x86_64-linux = "sha256-T5d9C2JSmN5y1PSpHLofTKOr32VxLDwjYH9UD0+wAXM=";
        aarch64-linux = "sha256-wUVqz3VPJ/ZEkS+6MJbbSqqS9vhHPGxTdAty5mIyKgA=";
        x86_64-darwin = "sha256-uPBTkOCZCpG3mb0D6S710vxaGRAaly5d3UHL1j/+uzo=";
        aarch64-darwin = "sha256-wfgk3+Z16FThXJdD34vxitXYx/4TdwqboMlXs5IAFDs=";
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
