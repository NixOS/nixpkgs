{ lib, stdenv, fetchFromGitHub, cmake
, fetchpatch
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "snappy";
  version = "1.1.10";

  src = fetchFromGitHub {
    owner = "google";
    repo = "snappy";
    rev = version;
    hash = "sha256-wYZkKVDXKCugycx/ZYhjV0BjM/NrEM0R6A4WFhs/WPU=";
  };

  patches = [
    # Re-enable RTTI, without which other applications can't subclass
    # snappy::Source (this breaks Ceph, as one example)
    # https://tracker.ceph.com/issues/53060
    # https://build.opensuse.org/package/show/openSUSE:Factory/snappy
    (fetchpatch {
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/snappy/reenable-rtti.patch?rev=a759aa6fba405cd40025e3f0ab89941d";
      sha256 = "sha256-RMuM5yd6zP1eekN/+vfS54EyY4cFbGDVor1E1vj3134=";
    })
<<<<<<< HEAD
    # Fix -Wsign-compare warning on clang.
    (fetchpatch {
      url = "https://github.com/google/snappy/commit/27f34a580be4a3becf5f8c0cba13433f53c21337.patch";
      sha256 = "sha256-eq6ueeMAkd2bYmPJcKAZZzd5QlXyeWOrsxFIwR8KOpQ=";
    })
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

<<<<<<< HEAD
=======
  # See https://github.com/NixOS/nixpkgs/pull/219778#issuecomment-1464884412
  # and https://github.com/NixOS/nixpkgs/pull/221215#issuecomment-1482564003.
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-sign-compare";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
    "-DSNAPPY_BUILD_TESTS=OFF"
    "-DSNAPPY_BUILD_BENCHMARKS=OFF"
  ];

  postInstall = ''
    substituteInPlace "$out"/lib/cmake/Snappy/SnappyTargets.cmake \
      --replace 'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include"' 'INTERFACE_INCLUDE_DIRECTORIES "'$dev'"'

    mkdir -p $dev/lib/pkgconfig
    cat <<EOF > $dev/lib/pkgconfig/snappy.pc
      Name: snappy
      Description: Fast compressor/decompressor library.
      Version: ${version}
      Libs: -L$out/lib -lsnappy
      Cflags: -I$dev/include
    EOF
  '';

  #checkTarget = "test";

  # requires gbenchmark and gtest but it also installs them out $dev
  doCheck = false;

  meta = with lib; {
    homepage = "https://google.github.io/snappy/";
    license = licenses.bsd3;
    description = "Compression/decompression library for very high speeds";
    platforms = platforms.all;
  };
}
