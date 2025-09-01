{
  lib,
  stdenv,
  fetchzip,
  glib,
  libgda6,
  gsound,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-pano";
  version = "23-alpha5";

  src = fetchzip {
    url = "https://github.com/oae/gnome-shell-pano/releases/download/v${finalAttrs.version}/pano@elhan.io.zip";
    hash = "sha256-kTaJOSyFtBa/fl3Mot8Q8qyhwJwhcbBY4FvdztqUP4w=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    glib
  ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict schemas
    runHook postBuild
  '';

  preInstall = ''
    substituteInPlace extension.js \
      --replace-fail "import Gda from 'gi://Gda?version>=5.0'" "imports.gi.GIRepository.Repository.prepend_search_path('${libgda6}/lib/girepository-1.0'); const Gda = (await import('gi://Gda')).default" \
      --replace-fail "import GSound from 'gi://GSound'" "imports.gi.GIRepository.Repository.prepend_search_path('${gsound}/lib/girepository-1.0'); const GSound = (await import('gi://GSound')).default"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r -T . $out/share/gnome-shell/extensions/pano@elhan.io
    runHook postInstall
  '';

  passthru = {
    extensionPortalSlug = "pano";
    extensionUuid = "pano@elhan.io";
  };

  meta = with lib; {
    description = "Next-gen Clipboard Manager for Gnome Shell";
    homepage = "https://github.com/oae/gnome-shell-pano";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ honnip ];
    platforms = platforms.linux;
  };
})
