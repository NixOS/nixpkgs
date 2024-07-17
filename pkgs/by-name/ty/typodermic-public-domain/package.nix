{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "typodermic-public-domain";
  version = "2022-11";

  src = fetchzip {
    url = "https://typodermicfonts.com/wp-content/uploads/2022/11/typodermic-public-domain-2022-11.zip";
    hash = "sha256-2hqpehQ4zxSvsw2dtom/fkMAayJKNvOdYs+c+rrvJKw=";
    curlOptsList = [
      "--user-agent"
      "Mozilla/5.0"
    ]; # unbreak their wordpress
    stripRoot = false;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts
    cp -a "$src/OpenType Fonts" "$out/share/fonts/opentype"
    runHook postInstall
  '';

  meta = {
    homepage = "https://typodermicfonts.com/";
    description = "Vintage Typodermic fonts";
    maintainers = with lib.maintainers; [ ehmry ];
    license = lib.licenses.cc0;
  };
}
