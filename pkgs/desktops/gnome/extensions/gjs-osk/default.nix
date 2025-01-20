{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
}:

let
  uuid = "gjsosk@vishram1123.com";
in
stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-gjs-osk";
  version = "0-unstable-2024-11-19";

  src = fetchFromGitHub {
    owner = "Vishram1123";
    repo = "gjs-osk";
    rev = "3e461bb25ec55117b168e9d364381511cb70e1f3";
    sha256 = "sha256-vRT3jjQTCJhf7KOSAXypYa0IMLD4xX7e2hbO3BTXfeI=";
  };

  nativeBuildInputs = [
    glib
  ];

  postPatch = ''
    pushd ${uuid}

    # gjs-osk will unpack keycodes.tar.xz to store at runtime if keycodes does not exist.
    mkdir keycodes
    tar xf keycodes.tar.xz -C keycodes

    sed 's/{{VERSION}}/${version}/g' -i prefs.js

    popd
  '';

  buildPhase = ''
    runHook preBuild
    glib-compile-schemas --strict ${uuid}/schemas
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    DIR=$out/share/gnome-shell/extensions
    mkdir -p $DIR
    cp -r ${uuid} $DIR

    runHook postInstall
  '';

  passthru = {
    extensionUuid = uuid;
    extensionPortalSlug = "gjs-osk";
  };

  meta = with lib; {
    description = "A (marginally) better on screen keyboard for GNOME 42+";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Anillc ];
    homepage = "https://github.com/Vishram1123/gjs-osk";
  };
}
