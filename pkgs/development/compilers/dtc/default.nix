{ stdenv
, lib
, fetchzip
, fetchpatch
, meson
, ninja
, flex
, bison
, pkg-config
, which
, pythonSupport ? false
, python ? null
, swig
, libyaml
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtc";
  version = "1.7.0";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git/snapshot/dtc-v${finalAttrs.version}.tar.gz";
    sha256 = "sha256-FMh3VvlY3fUK8fbd0M+aCmlUrmG9YegiOOQ7MOByffc=";
  };

  # Big pile of backports.
  # FIXME: remove all of these after next upstream release.
  patches = let
    fetchUpstreamPatch = { rev, hash }: fetchpatch {
      name = "dtc-${rev}.patch";
      url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git/patch/?id=${rev}";
      inherit hash;
    };
  in [
    # meson: Fix cell overflow tests when running from meson
    (fetchUpstreamPatch {
      rev = "32174a66efa4ad19fc6a2a6422e4af2ae4f055cb";
      hash = "sha256-C7OzwY0zq+2CV3SB5unI7Ill2M3deF7FXeQE3B/Kx2s=";
    })

    # Use #ifdef NO_VALGRIND
    (fetchUpstreamPatch {
      rev = "41821821101ad8a9f83746b96b163e5bcbdbe804";
      hash = "sha256-7QEFDtap2DWbUGqtyT/RgJZJFldKB8oSubKiCtLZ0w4=";
    })

    # dtc: Fix linker options so it also works in Darwin
    (fetchUpstreamPatch {
      rev = "71a8b8ef0adf01af4c78c739e04533a35c1dc89c";
      hash = "sha256-uLXL0Sjcn+bnMuF+A6PjUW1Rq6uNg1dQl58zbeYpP/U=";
    })

    # meson: allow disabling tests
    (fetchUpstreamPatch {
      rev = "bdc5c8793a13abb8846d115b7923df87605d05bd";
      hash = "sha256-cO4f/jJX/pQL7kk4jpKUhsCVESW2ZuWaTr7z3BuvVkw=";
    })

    # meson: fix installation with meson-python
    (fetchUpstreamPatch {
      rev = "3fbfdd08afd2a7a25b27433f6f5678c0fe694721";
      hash = "sha256-skK8m1s4xkK6x9AqzxiEK+1uMEmS27dBI1CdEXNFTfU=";
    })

    # pylibfdt: fix get_mem_rsv for newer Python versions
    (fetchUpstreamPatch {
      rev = "822123856980f84562406cc7bd1d4d6c2b8bc184";
      hash = "sha256-IJpRgP3pP8Eewx2PNKxhXZdsnomz2AR6oOsun50qAms=";
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
    !stdenv.hostPlatform.isDarwin &&
    # Checks are broken when building statically on x86_64 linux with musl
    # One of the test tries to build a shared library and this causes the linker:
    # x86_64-unknown-linux-musl-ld: /nix/store/h9gcvnp90mpniyx2v0d0p3s06hkx1v2p-x86_64-unknown-linux-musl-gcc-13.3.0/lib/gcc/x86_64-unknown-linux-musl/13.3.0/crtbeginT.o: relocation R_X86_64_32 against hidden symbol `__TMC_END__' can not be used when making a shared object
    # x86_64-unknown-linux-musl-ld: failed to set dynamic section sizes: bad value
    !stdenv.hostPlatform.isStatic &&

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
