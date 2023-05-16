{ stdenv
, lib
, fetchgit
, fetchpatch
<<<<<<< HEAD
, meson
, ninja
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, flex
, bison
, pkg-config
, which
, pythonSupport ? false
, python ? null
, swig
, libyaml
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "dtc";
  version = "1.7.0";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-FMh3VvlY3fUK8fbd0M+aCmlUrmG9YegiOOQ7MOByffc=";
  };

  patches = [
    # meson: Fix cell overflow tests when running from meson
    (fetchpatch {
      url = "https://github.com/dgibson/dtc/commit/32174a66efa4ad19fc6a2a6422e4af2ae4f055cb.patch";
      sha256 = "sha256-C7OzwY0zq+2CV3SB5unI7Ill2M3deF7FXeQE3B/Kx2s=";
    })

    # Use #ifdef NO_VALGRIND
    (fetchpatch {
      url = "https://github.com/dgibson/dtc/commit/41821821101ad8a9f83746b96b163e5bcbdbe804.patch";
      sha256 = "sha256-7QEFDtap2DWbUGqtyT/RgJZJFldKB8oSubKiCtLZ0w4=";
    })

    # dtc: Fix linker options so it also works in Darwin
    (fetchpatch {
      url = "https://github.com/dgibson/dtc/commit/3acde70714df3623e112cf3ec99fc9b5524220b8.patch";
      sha256 = "sha256-uLXL0Sjcn+bnMuF+A6PjUW1Rq6uNg1dQl58zbeYpP/U=";
    })

    # meson: allow disabling tests
    (fetchpatch {
      url = "https://github.com/dgibson/dtc/commit/35f26d2921b68d97fefbd5a2b6e821a2f02ff65d.patch";
      sha256 = "sha256-cO4f/jJX/pQL7kk4jpKUhsCVESW2ZuWaTr7z3BuvVkw=";
    })
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  nativeBuildInputs = [
    meson
    ninja
    flex
    bison
    pkg-config
    which
  ] ++ lib.optionals pythonSupport [
    python
    python.pkgs.setuptools-scm
    swig
  ];
=======
stdenv.mkDerivation rec {
  pname = "dtc";
  version = "1.6.1";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-gx9LG3U9etWhPxm7Ox7rOu9X5272qGeHqZtOe68zFs4=";
  };

  patches = [
    # fix python 3.10 compatibility
    # based on without requiring the setup.py rework
    # https://git.kernel.org/pub/scm/utils/dtc/dtc.git/commit/?id=383e148b70a47ab15f97a19bb999d54f9c3e810f
    ./python-3.10.patch

    # fix dtc static building
    ./0001-Depend-on-.a-instead-of-.so-when-building-static.patch
  ];

  nativeBuildInputs = [ flex bison pkg-config which ]
    ++ lib.optionals pythonSupport [ python swig ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ libyaml ];

  postPatch = ''
<<<<<<< HEAD
    patchShebangs setup.py

    # meson.build: bump version to 1.7.0
    substituteInPlace libfdt/meson.build \
      --replace "version: '1.6.0'," "version: '${finalAttrs.version}',"
    substituteInPlace meson.build \
      --replace "version: '1.6.0'," "version: '${finalAttrs.version}',"
  '';

  # Required for installation of Python library and is innocuous otherwise.
  env.DESTDIR = "/";

  mesonAutoFeatures = "auto";
  mesonFlags = [
    (lib.mesonBool "static-build" stdenv.hostPlatform.isStatic)
    (lib.mesonBool "tests" finalAttrs.finalPackage.doCheck)
  ];

  doCheck =
    # Checks are broken on aarch64 darwin
    # https://github.com/NixOS/nixpkgs/pull/118700#issuecomment-885892436
    !stdenv.isDarwin &&

    # we must explicitly disable this here so that mesonFlags receives
    # `-Dtests=disabled`; without it meson will attempt to run
    # hostPlatform binaries during the configurePhase.
    (with stdenv; buildPlatform.canExecute hostPlatform);
=======
    patchShebangs pylibfdt/
  '';

  makeFlags = [ "PYTHON=python" "STATIC_BUILD=${toString stdenv.hostPlatform.isStatic}" ];
  installFlags = [ "INSTALL=install" "PREFIX=$(out)" "SETUP_PREFIX=$(out)" ];

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/libfdt.dylib $out/lib/libfdt-${version}.dylib
  '';

  # Checks are broken on aarch64 darwin
  # https://github.com/NixOS/nixpkgs/pull/118700#issuecomment-885892436
  doCheck = !stdenv.isDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Device Tree Compiler";
    homepage = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    license = licenses.gpl2Plus; # dtc itself is GPLv2, libfdt is dual GPL/BSD
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
