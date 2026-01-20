{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  cython_0,
  zfs,
}:

buildPythonPackage rec {
  pname = "py-libzfs";
  version = "25.10.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "truenas";
    repo = "py-libzfs";
    rev = "TS-${version}";
    hash = "sha256-kme5qUG0Nsya8HxU/oMHP1AidoMMOob/EON8sZMzKKI=";
  };

  patches = [
    # Upstream has open PR. Debian uses the patch.
    # https://github.com/truenas/py-libzfs/pull/277
    (fetchpatch2 {
      url = "https://salsa.debian.org/python-team/packages/py-libzfs/-/raw/debian/0.0+git20240510.5ae7d5e-1/debian/patches/fix-compilation-on-gcc-14.patch";
      hash = "sha256-KLxRx2k1LQGtmzMqJe9b84ApOnIXn8ZeBZun5BAxEjc=";
    })
  ];

  build-system = [ cython_0 ];
  buildInputs = [ zfs ];

  # Passing CFLAGS in configureFlags does not work, see https://github.com/truenas/py-libzfs/issues/107
  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace configure \
      --replace-fail \
        'CFLAGS="-DCYTHON_FALLTHROUGH"' \
        'CFLAGS="-DCYTHON_FALLTHROUGH -I${zfs.dev}/include/libzfs -I${zfs.dev}/include/libspl"' \
      --replace-fail 'zof=false' 'zof=true'
  '';

  pythonImportsCheck = [ "libzfs" ];

  meta = {
    description = "Python libzfs bindings";
    homepage = "https://github.com/truenas/py-libzfs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ chuangzhu ];
    # The project also supports macOS (OpenZFS on OSX, O3X), FreeBSD and OpenSolaris
    # I don't have a machine to test out, thus only packaged for Linux
    platforms = lib.platforms.linux;
  };
}
