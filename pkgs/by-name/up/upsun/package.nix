{ stdenvNoCC, lib, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "upsun";
  version = "5.0.12";

  src = {
    x86_64-linux = fetchurl {
      url = "https://github.com/platformsh/cli/releases/download/${version}/upsun_${version}_linux_amd64.tar.gz";
      hash = "sha256-svEPMVY7r7pAoXwFIMYqCEduqR3Nkocaguf2nIGt+G8=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/platformsh/cli/releases/download/${version}/upsun_${version}_linux_arm64.tar.gz";
      hash = "sha256-ZraS/PqSPL/kcj5o6hzDdL70IV2IWXOma6OHCiXIDQc=";
    };
  }.${stdenvNoCC.system} or (throw "${pname}-${version}: ${stdenvNoCC.system} is unsupported.");

  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";
  installPhase = ''
    install -Dm755 upsun $out/bin/upsun
  '';

  meta = {
    homepage = "https://github.com/platformsh/cli";
    description = "The unified tool for managing your Upsun services from the command line";
    maintainers = with lib.maintainers; [ spk ];
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
