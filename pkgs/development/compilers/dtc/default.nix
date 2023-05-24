{ stdenv
, lib
, fetchgit
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

stdenv.mkDerivation rec {
  pname = "dtc";
  version = "1.7.0";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-FMh3VvlY3fUK8fbd0M+aCmlUrmG9YegiOOQ7MOByffc=";
  };

  patches = [
    # meson: Fix cell overflow tests when running from meson
    (fetchpatch {
      url = "https://github.com/dgibson/dtc/commit/32174a66efa4ad19fc6a2a6422e4af2ae4f055cb.patch";
      sha256 = "sha256-C7OzwY0zq+2CV3SB5unI7Ill2M3deF7FXeQE3B/Kx2s=";
    })

    # meson.build: bump version to 1.7.0
    (fetchpatch {
      url = "https://github.com/dgibson/dtc/commit/64a907f08b9bedd89833c1eee674148cff2343c6.patch";
      sha256 = "sha256-p2KGS5GW+3uIPgXfuIx6aDC54csM+5FZDkK03t58AL8=";
    })

    # Fix version in libfdt/meson.build
    (fetchpatch {
      url = "https://github.com/dgibson/dtc/commit/723545ebe9933b90ea58dc125e4987c6bcb04ade.patch";
      sha256 = "sha256-5Oq7q+62ZObj3e7rguN9jhSpYoQkwjSfo/N893229dQ=";
    })

    # Use #ifdef NO_VALGRIND
    (fetchpatch {
      url = "https://github.com/dgibson/dtc/commit/41821821101ad8a9f83746b96b163e5bcbdbe804.patch";
      sha256 = "sha256-7QEFDtap2DWbUGqtyT/RgJZJFldKB8oSubKiCtLZ0w4=";
    })
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
  '';

  # Required for installation of Python library and is innocuous otherwise.
  env.DESTDIR = "/";

  mesonAutoFeatures = "auto";
  mesonFlags = [
    (lib.mesonBool "static-build" stdenv.hostPlatform.isStatic)
  ];

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -id $out/lib/libfdt.dylib $out/lib/libfdt-${version}.dylib
  '';

  # Checks are broken on aarch64 darwin
  # https://github.com/NixOS/nixpkgs/pull/118700#issuecomment-885892436
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Device Tree Compiler";
    homepage = "https://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    license = licenses.gpl2Plus; # dtc itself is GPLv2, libfdt is dual GPL/BSD
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
  };
}
