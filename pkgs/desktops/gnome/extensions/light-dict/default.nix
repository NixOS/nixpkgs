{
  lib,
  replaceVars,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3, # src/ldocr.py
  bash, # cli/*.sh
  gobject-introspection, # src/ldocr.py
  sassc, # res/style/meson.build, res/data/theme/meson.build
  gjs, # res/data/scalable/status/meson.build
  libsoup_3,
  libxml2, # res/data/extension_gresource require xmllint
  gettext, # cli/update-po.sh
  curl, # cli/get-version.sh
  glib, # meson.build
}:

let
  python3-env =
    python3.withPackages # src/ldocr.py
      (
        ps: with ps; [
          # for OCR
          opencv4
          pytesseract
          pygobject3
        ]
      );
in

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-light-dict";
  version = "49.0";

  src = fetchFromGitHub {
    owner = "tuberry";
    repo = "light-dict";
    rev = version;
    sha256 = "sha256-+c5Mw9LfvPdxgeDk9Zoeh9YZvT+lnnKnRtQ0AUcJlrE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sassc
    gjs
    libsoup_3
    libxml2
    gettext
    curl
    glib
  ];

  patches = [
    (replaceVars ./fix-paths.patch {
      bash-path = lib.meta.getExe bash;
      python-executable-path = lib.meta.getExe python3-env;
    })
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "###gnome-shell-extensions-path###" "$out/share/gnome-shell/extensions/"
  '';

  configurePhase = ''
    meson setup build
  '';

  buildPhase = ''
    meson install -C build
  '';

  dontInstall = true;

  buildInputs = [
    gobject-introspection
    python3-env
  ];

  passthru = {
    extensionUuid = "light-dict@tuberry.github.io";
    extensionPortalSlug = "light-dict";
  };

  meta = {
    description = "Manipulate primary selections on the fly, typically used as Lightweight Dictionaries";
    homepage = "https://github.com/tuberry/light-dict";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ caterpillar ];
    platforms = lib.platforms.all;
  };
}
