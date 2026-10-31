{
  qtModule,
  stdenv,
  lib,
  fetchFromGitHub,
  testers,
  unstableGitUpdater,
  qtbase,
  qtdeclarative,
}:

let
  sharedCmakePkgconfigModules = [
    "Qt6Contacts"
    "Qt6Organizer"
    "Qt6VersitOrganizer"
    "Qt6Versit"
  ];

  pkg = qtModule rec {
    pname = "qtpim";

    # qtpim has no official releases
    version = "6.12.0-beta1-unstable-2026-07-06";
    src = fetchFromGitHub {
      owner = "qt";
      repo = "qtpim";
      rev = "d03b5f636cd109848eacd8742f972b141805f365";
      hash = "sha256-AekhLGv8IOaC4cB1sVmorwiEkj1+fBPpQEMu17S3mNo=";
      name = "qtpim-src-${version}";
    };

    # Avoid test plugins getting installed
    postPatch = ''
      substituteInPlace \
        tests/auto/contacts/qcontactasync/maliciousplugin/CMakeLists.txt \
        tests/auto/contacts/qcontactmanagerplugins/dummyplugincopy/CMakeLists.txt \
        tests/auto/contacts/qcontactmanagerplugins/dummyplugin/CMakeLists.txt \
        tests/auto/contacts/qcontactmanagerplugins/dummyotherplugin/CMakeLists.txt \
        tests/auto/organizer/qorganizeritemasync/maliciousplugin/CMakeLists.txt \
        tests/auto/versit/qversitcontactplugins/plugin1/CMakeLists.txt \
        tests/auto/versit/qversitcontactplugins/plugin2/CMakeLists.txt \
        tests/auto/versit/qversitcontactplugins/plugin3/CMakeLists.txt \
        tests/auto/versit/qversitcontactplugins/plugin4/CMakeLists.txt \
        tests/auto/versit/qversitcontactplugins/plugin5/CMakeLists.txt \
        --replace-fail \
          'TEST_PLUGIN' \
          'TEST_PLUGIN SKIP_INSTALL'
    '';

    propagatedBuildInputs = [
      qtbase
      qtdeclarative
    ];

    cmakeFlags = [
      (lib.cmakeBool "QT_BUILD_TESTS" doCheck)
    ];

    doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

    # Expects everything to be installed into qtbase
    preCheck = ''
      export QML2_IMPORT_PATH=${
        lib.makeSearchPathOutput "bin" qtbase.qtQmlPrefix [ qtdeclarative ]
      }:$PWD/${qtbase.qtQmlPrefix}
    '';

    # Ensure no test plugin snuck its way into the output
    postFixup = ''
      readarray -d "" testPlugins < <(find $out/${qtbase.qtPluginPrefix} -type f -and -not -name 'libqt*.so' -print0)
      if [ ''${#testPlugins[@]} -ne 0 ]; then
        echo "!!! Found test plugins in output !!!"
        echo "Some of them test malicious plugin behaviour, so we don't want to have them in the final output."
        echo "Make sure these libraries get marked with SKIP_INSTALL in CMake code:"
        for testPlugin in "''${testPlugins[@]}"; do
          echo "- $testPlugin"
        done
        exit 1
      fi
    '';

    env = {
      # Sorting tests misbehave on LANG=C
      LANG = "en_US.UTF-8";

      # Otherwise QML tests fail to load xcb. Test macros from qtbase override QT_PLUGIN_PATH, so can't add qtbase path.
      QT_QPA_PLATFORM = "minimal";
    };

    passthru = {
      updateScript = unstableGitUpdater {
        tagPrefix = "v";
      };
    };

    meta = {
      # Upstream Qt6 revival is due to usage in Lomiri stack
      teams = [ lib.teams.lomiri ];

      cmakeConfigModules = lib.lists.concatMap (module: [
        module
        "${module}Private"
      ]) sharedCmakePkgconfigModules;

      pkgConfigModules =
        sharedCmakePkgconfigModules
        # Unsure if these are supposed to be exposed, but they're there...
        # CMake finding of them fails, needs _qt_internal_should_include_targets function from qtbase
        ++ [
          "Qt6declarative_contacts"
          "Qt6declarative_organizer"
        ];
    };
  };
in
pkg
// {
  passthru = pkg.passthru // {
    tests = (pkg.passthru.tests or { }) // {
      cmake = testers.hasCmakeConfigModules {
        package = pkg;
        versionCheck = false;
      };

      pkg-config = testers.hasPkgConfigModules {
        package = pkg;
        versionCheck = false;
      };
    };
  };
}
