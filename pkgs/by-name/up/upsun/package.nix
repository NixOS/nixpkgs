{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "upsun";
  version = "5.0.12";

  src = fetchurl {
    url = "https://github.com/platformsh/cli/releases/download/${version}/${pname}_${version}_linux_amd64.tar.gz";
    sha256 = "sha256-svEPMVY7r7pAoXwFIMYqCEduqR3Nkocaguf2nIGt+G8=";
  };

  dontConfigure = true;
  dontBuild = true;
  preferLocalBuild = true;

  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/bin
    cp -pr upsun $out/bin
  '';

  meta = {
    homepage = "https://github.com/platformsh/cli";
    description = "The unified tool for managing your Upsun services from the command line.";
    maintainers = with lib.maintainers; [ spk ];
    license = lib.licenses.mit;
    platforms = with lib.platforms; unix;
  };
}
