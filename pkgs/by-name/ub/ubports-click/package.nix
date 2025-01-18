{
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  lib,
  stdenv,
  testers,
  autoreconfHook,
  dbus,
  dbus-test-runner,
  dpkg,
  getopt,
  glib,
  gobject-introspection,
  json-glib,
  libgee,
  perl,
  pkg-config,
  properties-cpp,
  python3Packages,
  vala,
  wrapGAppsHook3,
}:

let
  self = python3Packages.buildPythonApplication rec {
    pname = "click";
    version = "0.5.2";
    format = "other";

    src = fetchFromGitLab {
      owner = "ubports";
      repo = "development/core/click";
      rev = version;
      hash = "sha256-AV3n6tghvpV/6Ew6Lokf8QAGBIMbHFAnp6G4pefVn+8=";
    };

    patches = [
      # Remove when version > 0.5.2
      (fetchpatch {
        name = "0001-click-fix-Wimplicit-function-declaration.patch";
        url = "https://gitlab.com/ubports/development/core/click/-/commit/8f654978a12e6f9a0b6ff64296ec5565e3ff5cd0.patch";
        hash = "sha256-kio+DdtuagUNYEosyQY3q3H+dJM3cLQRW9wUKUcpUTY=";
      })

      # Remove when version > 0.5.2
      (fetchpatch {
        name = "0002-click-Add-uid_t-and-gid_t-to-the-ctypes-_typemap.patch";
        url = "https://gitlab.com/ubports/development/core/click/-/commit/cbcd23b08b02fa122434e1edd69c2b3dcb6a8793.patch";
        hash = "sha256-QaWRhxO61wAzULVqPLdJrLuBCr3+NhKmQlEPuYq843I=";
      })
    ];

    postPatch = ''
      # These should be proper Requires, using the header needs their headers
      substituteInPlace lib/click/click-*.pc.in \
        --replace-fail 'Requires.private' 'Requires'

      # Don't completely override PKG_CONFIG_PATH
      substituteInPlace click_package/tests/Makefile.am \
        --replace-fail 'PKG_CONFIG_PATH=$(top_builddir)/lib/click' 'PKG_CONFIG_PATH=$(top_builddir)/lib/click:$(PKG_CONFIG_PATH)'

      patchShebangs bin/click
    '';

    strictDeps = true;

    pkgsBuildBuild = [
      pkg-config
    ];

    nativeBuildInputs = [
      autoreconfHook
      dbus-test-runner # Always checking for this
      getopt
      gobject-introspection
      perl
      pkg-config
      vala
      wrapGAppsHook3
    ];

    buildInputs = [
      glib
      json-glib
      libgee
      properties-cpp
    ];

    propagatedBuildInputs = with python3Packages; [
      python-debian
      pygobject3
      setuptools
    ];

    nativeCheckInputs = [
      dbus
      dpkg
      python3Packages.unittestCheckHook
    ];

    checkInputs = with python3Packages; [
      python-apt
      six
    ];

    preConfigure = ''
      export click_cv_perl_vendorlib=$out/${perl.libPrefix}
      export PYTHON_INSTALL_FLAGS="--prefix=$out"
    '';

    configureFlags = [
      "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
      "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user"
    ];

    enableParallelBuilding = true;

    doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

    disabledTestPaths = [
      # From apt: Unable to determine a suitable packaging system type
      "click_package/tests/integration/test_signatures.py"
      "click_package/tests/test_build.py"
      "click_package/tests/test_install.py"
      "click_package/tests/test_scripts.py"
    ];

    preCheck = ''
      export HOME=$TMP

      # tests recompile some files for loaded predefines, doesn't use any optimisation level for it
      # makes test output harder to read, so make the warning go away
      export NIX_CFLAGS_COMPILE+=" -U_FORTIFY_SOURCE"

      # Haven'tbeen able to get them excluded via disabledTest{s,Paths}, just deleting them
      for path in $disabledTestPaths; do
        rm -v $path
      done
    '';

    preFixup = ''
      makeWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "$out/lib"
      )
    '';

    passthru = {
      updateScript = gitUpdater { };
    };

    meta = {
      description = "Tool to build click packages, mainly used for Ubuntu Touch";
      homepage = "https://gitlab.com/ubports/development/core/click";
      changelog = "https://gitlab.com/ubports/development/core/click/-/blob/${version}/ChangeLog";
      license = lib.licenses.gpl3Only;
      mainProgram = "click";
      maintainers =
        with lib.maintainers;
        [
          ilyakooo0
        ]
        ++ lib.teams.lomiri.members;
      platforms = lib.platforms.linux;
      pkgConfigModules = [
        "click-0.4"
      ];
    };
  };
in
self
// {
  passthru = self.passthru // {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = self;
    };
  };
}
