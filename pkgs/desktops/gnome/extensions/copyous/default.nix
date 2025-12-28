{
  lib,
  stdenv,
  fetchzip,
  glib,
  libgda6,
  gsound,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell-extension-copyous";
  version = "1.2.0";

  src = fetchzip {
    url = "https://github.com/boerdereinar/copyous/releases/download/v${finalAttrs.version}/copyous@boerdereinar.dev.zip";
    hash = "sha256-3yE0+F/E1/qrGGO6loaMoCzf5gtT1j964/HdytU0ePM=";
    stripRoot = false;
  };

  nativeBuildInputs = [ glib ];

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict schemas
    runHook postBuild
  '';

  preInstall = ''
    sed -i "1i import GIRepository from 'gi://GIRepository';\nGIRepository.Repository.dup_default().prepend_search_path('${libgda6}/lib/girepository-1.0');\nGIRepository.Repository.dup_default().prepend_search_path('${gsound}/lib/girepository-1.0');\n" lib/preferences/dependencies/dependencies.js
    sed -i "1i import GIRepository from 'gi://GIRepository';\nGIRepository.Repository.dup_default().prepend_search_path('${libgda6}/lib/girepository-1.0');\n" lib/misc/db.js
    sed -i "1i import GIRepository from 'gi://GIRepository';\nGIRepository.Repository.dup_default().prepend_search_path('${gsound}/lib/girepository-1.0');\n" lib/common/sound.js
    sed -i "1i import GIRepository from 'gi://GIRepository';\nGIRepository.Repository.dup_default().prepend_search_path('${gsound}/lib/girepository-1.0');\n" lib/preferences/general/feedbackSettings.js
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -r -T . $out/share/gnome-shell/extensions/copyous@boerdereinar.dev
    runHook postInstall
  '';

  passthru = {
    extensionPortalSlug = "copyous";
    extensionUuid = "copyous@boerdereinar.dev";
  };

  meta = with lib; {
    description = "Modern Clipboard Manager for GNOME";
    homepage = "https://github.com/boerdereinar/copyous";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jmir ];
    platforms = platforms.linux;
  };
})
