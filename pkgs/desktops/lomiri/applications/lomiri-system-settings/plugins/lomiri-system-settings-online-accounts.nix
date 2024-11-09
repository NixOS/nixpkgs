{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  accounts-qt,
  lomiri-online-accounts,
  lomiri-online-accounts-plugins,
  lomiri-system-settings-unwrapped,
  pkg-config,
  qmake,
  qtdeclarative,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-system-settings-online-accounts";
  version = "0.12";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-system-settings-online-accounts";
    rev = finalAttrs.version;
    hash = "sha256-HXu4xIiF1GAVNf7j0+3J9b8xKcQoZvTAZoDZ9BP7UX0=";
  };

  patches = [
    # Remove when version > 0.12
    (fetchpatch {
      name = "0001-lomiri-system-settings-online-accounts-Fix-LOA-porting-mistake.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-system-settings-online-accounts/-/commit/0619fa9d81c244d69744aff3cd96eda16da8fe7d.patch";
      hash = "sha256-/s9F+fnbGqlCKeFSIZtqeHjx3PN2XMbCLNnJIH2nSck=";
    })
  ];

  postPatch = ''
    # Get rid of harmless warning
    substituteInPlace po/po.pro \
      --replace-fail 'message("")' 'message(" ")'

    substituteInPlace common-project-config.pri \
      --replace-fail '--define-variable=prefix=''$''${INSTALL_PREFIX}' '--define-variable=prefix=''$''${INSTALL_PREFIX} --define-variable=libdir=''$''${INSTALL_PREFIX}/lib'
  '';

  nativeBuildInputs = [
    pkg-config
    qmake
  ];

  buildInputs = [
    accounts-qt
    lomiri-system-settings-unwrapped
    qtdeclarative
  ];

  propagatedBuildInputs = [
    lomiri-online-accounts
  ];

  dontWrapQtApps = true;

  postConfigure = ''
    make qmake_all
  '';

  passthru = {
    # Is this the correct "spot" to propagate this? Needed because LOA usage calls accountsservice, which needs to find LOA-plugins in XDG_DATA_DIRS
    extraSearchPrefixes = [ lomiri-online-accounts-plugins ];
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Online accounts management plugin for Lomiri system settings";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-system-settings-online-accounts";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-system-settings-online-accounts/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
