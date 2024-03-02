{ fetchFromGitHub
, gitUpdater
, lib
, stdenvNoCC
}:

stdenvNoCC.mkDerivation {
  pname = "sweet-nova";
  version = "unstable-2023-09-30";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "Sweet";
    rev = "6e82150d7c3bb1e30ed9bd64de4d2ddd8e113205";
    hash = "sha256-vy4SO1j4y/cUmbQJNqW1/EPJljEtaRrigYIg4yMKXr4=";
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
