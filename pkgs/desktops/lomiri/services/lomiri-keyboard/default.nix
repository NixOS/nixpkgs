{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  anthy,
  gsettings-qt,
  hunspell,
  libchewing,
  libpinyin,
  maliit-framework,
  pkg-config,
  qmake,
  qtbase,
  qtdeclarative,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-keyboard";
  version = "1.0.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-keyboard";
    tag = finalAttrs.version;
    hash = "sha256-y5BGXh/ZGf4/2AWVIi4aSgHmL0DOd//iTk44VaL4+MI=";
  };

  patches = [
    # Remove when version > 1.0.3
    (fetchpatch {
      name = "0001-lomiri-keyboard-Dont-require-ordered-subdir-processing.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-keyboard/-/commit/96b6e196c6defb04a3338e0f43e21417075856d1.patch";
      hash = "sha256-8wSmMlYsEl6jZbjPisbsieobJdmCbaW/4v5bllTB5vE=";
    })

    ./2000-plugins-Make-presage-opt-in.patch
  ];

  postPatch = ''
    # Rip out QML plugin, we don't plan on using/shipping it
    rm -r src/imports
    substituteInPlace src/src.pro \
      --replace-fail 'imports' ""

    substituteInPlace config.pri \
      --replace-fail '$${MALIIT_PLUGINS_DATA_DIR}' "$out/share/maliit/plugins"

    substituteInPlace src/plugin/plugin.pro \
      --replace-fail '$${MALIIT_PLUGINS_DIR}' "$out/lib/maliit"

    substituteInPlace \
      config.pri \
      src/lib/logic/wordengine.cpp \
      po/po.pro \
      --replace-fail '/usr' "$out"

    # This just seems wrong, it should have flags for setting rpath flags but is set to just a path instead
    substituteInPlace \
      tests/unittests/ut_text/ut_text.pro \
      tests/unittests/ut_editor/ut_editor.pro \
      tests/unittests/ut_languagefeatures/ut_languagefeatures.pro \
      --replace-fail 'QMAKE_LFLAGS_RPATH' '# QMAKE_LFLAGS_RPATH'

    # LOMIRI_KEYBOARD_PLUGIN_LIB is shared, this variable is for static libraries
    substituteInPlace \
      tests/unittests/common/common.pro \
      tests/unittests/ut_wordengine/ut_wordengine.pro \
      tests/unittests/ut_word-candidates/ut_word-candidates.pro \
      --replace-fail 'PRE_TARGETDEPS += $${TOP_BUILDDIR}/$${LOMIRI_KEYBOARD_PLUGIN_LIB}' 'PRE_TARGETDEPS +='

    # line 6: LD_LIBRARY_PATH: not found
    substituteInPlace tests/unittests/common-check.pri \
      --replace-fail '$(LD_LIBRARY_PATH)' '$$(LD_LIBRARY_PATH)'

    # Don't install tests & their data, please
    find tests -name '*.pro' -exec sed -i -e 's/INSTALLS/#INSTALLS/g' -e 's/testcase/testcase no_testcase_installs/g' {} \;
  '';

  nativeBuildInputs = [
    pkg-config
    qmake
  ];

  buildInputs = [
    anthy
    gsettings-qt # missing pkg-config check
    hunspell
    libchewing
    libpinyin
    maliit-framework
    qtdeclarative
  ];

  dontWrapQtApps = true;

  qmakeFlags =
    [
      "MALIIT_DEFAULT_PROFILE=lomiri"
      "CONFIG+=enable-hunspell"
      "CONFIG+=enable-pinyin"
    ]
    ++ lib.optionals (!finalAttrs.finalPackage.doCheck) [
      "CONFIG+=notests"
    ];

  postConfigure = ''
    make qmake_all
  '';

  doCheck = true;

  preCheck =
    let
      listToQtVar =
        list: suffix: lib.strings.concatMapStringsSep ":" (drv: "${lib.getBin drv}/${suffix}") list;
    in
    ''
      export QT_QPA_PLATFORM=minimal
      export QT_PLUGIN_PATH=${listToQtVar [ qtbase ] qtbase.qtPluginPrefix}
    '';

  meta = {
    description = "Ubuntu Touch keyboard as maliit plugin";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-keyboard";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-keyboard/-/blob/${
      if (!builtins.isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = lib.licenses.lgpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
