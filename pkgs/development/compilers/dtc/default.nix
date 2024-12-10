{
  stdenv,
  lib,
  fetchzip,
  fetchpatch,
  meson,
  ninja,
  flex,
  bison,
  pkg-config,
  which,
  pythonSupport ? false,
  python ? null,
  swig,
  libyaml,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtc";
  version = "1.7.0";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git/snapshot/dtc-v${finalAttrs.version}.tar.gz";
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

    (fetchpatch {
      name = "static.patch";
      url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git/patch/?id=3fbfdd08afd2a7a25b27433f6f5678c0fe694721";
      hash = "sha256-skK8m1s4xkK6x9AqzxiEK+1uMEmS27dBI1CdEXNFTfU=";
    })
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  nativeBuildInputs =
    [
      meson
      ninja
      flex
      bison
      pkg-config
      which
    ]
    ++ lib.optionals pythonSupport [
      python
      python.pkgs.setuptools-scm
      swig
    ];

  buildInputs = [ libyaml ];

  postPatch = ''
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
    !stdenv.isDarwin
    &&

      # we must explicitly disable this here so that mesonFlags receives
      # `-Dtests=disabled`; without it meson will attempt to run
      # hostPlatform binaries during the configurePhase.
      (with stdenv; buildPlatform.canExecute hostPlatform);

  meta = with lib; {
    description = "Device Tree Compiler";
    homepage = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    license = licenses.gpl2Plus; # dtc itself is GPLv2, libfdt is dual GPL/BSD
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
    mainProgram = "dtc";
  };
})
