{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, cython
, fetchpatch2
, zfs
}:

buildPythonPackage rec {
  pname = "py-libzfs";
  version = "22.12.4.2";

  src = fetchFromGitHub {
    owner = "truenas";
    repo = pname;
    rev = "TS-${version}";
    hash = "sha256-vBLbjP1gQEQNsTLc2W6uRzCFHQXZp+jGiwE0Pe8VTuw=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/truenas/py-libzfs/commit/b5ffe1f1d6097df6e2f5cc6dd3c968872ec60804.patch";
      hash = "sha256-6r5hQ/o7c4vq4Tfh0l1WbeK3AuPvi+1wzkwkIn1qEes=";
    })
  ];

  nativeBuildInputs = [ cython ];
  buildInputs = [ zfs ];

  # Passing CFLAGS in configureFlags does not work, see https://github.com/truenas/py-libzfs/issues/107
  postPatch = lib.optionalString stdenv.isLinux ''
    substituteInPlace configure \
      --replace \
        'CFLAGS="-DCYTHON_FALLTHROUGH"' \
        'CFLAGS="-DCYTHON_FALLTHROUGH -I${zfs.dev}/include/libzfs -I${zfs.dev}/include/libspl"' \
      --replace 'zof=false' 'zof=true'
  '';

  pythonImportsCheck = [ "libzfs" ];

  meta = with lib; {
    description = "Python libzfs bindings";
    homepage = "https://github.com/truenas/py-libzfs";
    license = licenses.bsd2;
    maintainers = with maintainers; [ chuangzhu ];
    # The project also supports macOS (OpenZFS on OSX, O3X), FreeBSD and OpenSolaris
    # I don't have a machine to test out, thus only packaged for Linux
    platforms = platforms.linux;
  };
}

