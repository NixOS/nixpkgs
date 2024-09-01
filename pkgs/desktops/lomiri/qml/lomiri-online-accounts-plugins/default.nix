{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  autoreconfHook,
  gobject-introspection,
  libaccounts-glib,
  libsignon-glib,
  libxml2,
  lomiri-online-accounts,
  pkg-config,
  python3,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-online-accounts-plugins";
  version = "0.17";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-online-accounts-plugins";
    rev = finalAttrs.version;
    hash = "sha256-T5MEc0/zKPdbLxYy4MTuNfXQdBW6wYt0byaY1faPWxU=";
  };

  postPatch = ''
    substituteInPlace tools/lomiri-account-console \
      --replace-fail 'see /usr/share' "see $out/share"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    gobject-introspection
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    libaccounts-glib
    libsignon-glib
    lomiri-online-accounts
    (python3.withPackages (
      ps: with ps; [
        pygobject3
        (toPythonModule libaccounts-glib.py)
      ]
    ))
  ];

  nativeCheckInputs = [
    libxml2 # xmllint
  ];

  configureFlags = [ (lib.strings.enableFeature finalAttrs.finalPackage.doCheck "tests") ];

  enableParallelBuilding = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Account configuration plugins for the credentials configuration panel";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-online-accounts-plugins";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-online-accounts-plugins/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
