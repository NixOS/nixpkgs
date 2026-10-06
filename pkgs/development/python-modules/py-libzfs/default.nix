{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  zfs_2_3,
}:

buildPythonPackage rec {
  pname = "libzfs";
  version = "2.4.1-4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "45Drives";
    repo = "python3-libzfs";
    rev = "v${version}";
    hash = "sha256-0VSjCwGuo2khGKs7eTRhqpZBiFWGSwyRRyLPew4jAt8=";
  };

  # Remove some leftover uses of `long`, which does not exist in Python 3
  patches = [ ./python3.patch ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version='1.1'" "version='${version}'"
  '';

  build-system = [
    cython
    setuptools
  ];

  # The configure script checks for ZFS headers specifically in $prefix
  # and we don't actually use the generated install phase, so we can
  # just lie to it in this stupid way.
  configureFlags = [
    "--prefix=${zfs_2_3.dev}"
  ];

  # The configure script also expects the compiler to just know where all the libraries are,
  # so we have to help it. Also Wno-error away some constness errors.
  env = {
    NIX_CFLAGS_COMPILE = "-I${zfs_2_3.dev}/include/libzfs -I${zfs_2_3.dev}/include/libspl -Wno-error=incompatible-pointer-types";
    NIX_CFLAGS_LINK = "-L${zfs_2_3}/lib";
  };

  pythonImportsCheck = [ "libzfs" ];

  meta = {
    description = "Python libzfs bindings";
    homepage = "https://github.com/45Drives/python3-libzfs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ chuangzhu ];
    # The project also supports macOS (OpenZFS on OSX, O3X), FreeBSD and OpenSolaris
    # I don't have a machine to test out, thus only packaged for Linux
    platforms = lib.platforms.linux;
  };
}
