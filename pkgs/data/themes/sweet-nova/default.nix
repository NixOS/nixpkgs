{ fetchFromGitHub
, gitUpdater
, lib
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "sweet-nova";
  version = "unstable-2023-04-02";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Sweet";
    rev = "8a5d5a7d975567b5ae101b9f9d436fb1db2d9b24";
    hash = "sha256-FVcXBxcS5oFsvAUDcwit7EIfgIQznl8AYYxqQ797ddU=";
  };

  buildPhase = ''
    runHook preBuild
    cd kde
    mkdir -p aurorae/themes
    mv aurorae/Sweet-Dark aurorae/themes/Sweet-Dark
    mv aurorae/Sweet-Dark-transparent aurorae/themes/Sweet-Dark-transparent
    rm aurorae/.shade.svg
    mv colorschemes color-schemes
    mkdir -p plasma/look-and-feel
    mv look-and-feel plasma/look-and-feel/com.github.eliverlara.sweet
    mv sddm sddm-Sweet
    mkdir -p sddm/themes
    mv sddm-Sweet sddm/themes/Sweet
    mv cursors icons
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -d $out/share
    cp -r Kvantum aurorae color-schemes icons konsole plasma sddm $out/share
    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "A dark and colorful, blurry theme for the KDE Plasma desktop";
    homepage = "https://github.com/EliverLara/Sweet";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.dr460nf1r3 ];
    platforms = platforms.all;
  };
}
