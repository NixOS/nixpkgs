{
  lib,
  stdenv,
  fetchurl,
  zeroad-unwrapped,
}:

stdenv.mkDerivation rec {
  pname = "0ad-data";
  inherit (zeroad-unwrapped) version;

  src = fetchurl {
<<<<<<< HEAD
    url = "https://releases.wildfiregames.com/0ad-${version}-unix-data.tar.xz";
=======
    url = "http://releases.wildfiregames.com/0ad-${version}-unix-data.tar.xz";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-g34tbd8TiwJfwCAXJF11gaS7hP2UtCwOYF0yG3AXqZg=";
  };

  installPhase = ''
    rm binaries/data/tools/fontbuilder/fonts/*.txt
    mkdir -p $out/share/0ad
    cp -r binaries/data $out/share/0ad/
  '';

<<<<<<< HEAD
  meta = {
    description = "Free, open-source game of ancient warfare -- data files";
    homepage = "https://play0ad.com/";
    license = lib.licenses.cc-by-sa-30;
    maintainers = with lib.maintainers; [ chvp ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Free, open-source game of ancient warfare -- data files";
    homepage = "https://play0ad.com/";
    license = licenses.cc-by-sa-30;
    maintainers = with maintainers; [ chvp ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hydraPlatforms = [ ];
  };
}
