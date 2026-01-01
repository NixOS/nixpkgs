{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "typodermic-free-fonts";
<<<<<<< HEAD
  version = "2024-12";

  src = fetchzip {
    url = "https://typodermicfonts.com/wp-content/uploads/2024/12/typodermic-free-fonts-2024d.zip";
    hash = "sha256-tfv0PTu1gOWXxaoiQJNqnhJKGChGlGJqsqsb/xvBfGU=";
=======
  version = "2024-04";

  src = fetchzip {
    url = "https://typodermicfonts.com/wp-content/uploads/2024/04/typodermic-free-fonts-2024b.zip";
    hash = "sha256-EbK2wrYdIFmz/gdM+46CNb4Z21jrVYZMh+dtduwC8aI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    curlOptsList = [
      "--user-agent"
      "Mozilla/5.0"
    ]; # unbreak their wordpress
    stripRoot = false;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
<<<<<<< HEAD
    mkdir -p $out/share/fonts/opentype/
    cp "$src/"*.otf $out/share/fonts/opentype/
=======
    mkdir -p $out/share/fonts
    cp -a "$src/Typodermic Fonts" "$out/share/fonts/opentype"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    runHook postInstall
  '';

  meta = {
    homepage = "https://typodermicfonts.com/";
    description = "Typodermic fonts";
    license = lib.licenses.unfree // {
      fullName = "Font Software for Desktop End User License Agreement";
      url = "https://typodermicfonts.com/end-user-license-agreement/";
    }; # Font is fine for use in printing and display but cannot be embbeded.
  };
}
