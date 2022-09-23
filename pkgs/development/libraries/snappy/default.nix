{ lib, stdenv, fetchFromGitHub, cmake
, fetchpatch
, static ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "snappy";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "google";
    repo = "snappy";
    rev = version;
    sha256 = "sha256-JXWl63KVP+CDNWIXYtz+EKqWLJbPKl3ifhr8dKAp/w8=";
  };

  patches = [
    (fetchpatch {
      name = "clang-7-compat.patch";
      url = "https://github.com/google/snappy/pull/142/commits/658cb2fcf67b626fff2122a3dbf7a3560c58f7ee.patch";
      sha256 = "1kg3lxjwmhc7gjx36nylilnf444ddbnr3px1wpvyc6l1nh6zh4al";
    })
    # Re-enable RTTI, without which other applications can't subclass
    # snappy::Source (this breaks Ceph, as one example)
    # https://tracker.ceph.com/issues/53060
    # https://build.opensuse.org/package/show/openSUSE:Factory/snappy
    (fetchpatch {
      url = "https://build.opensuse.org/public/source/openSUSE:Factory/snappy/reenable-rtti.patch?rev=a759aa6fba405cd40025e3f0ab89941d";
      sha256 = "sha256-RMuM5yd6zP1eekN/+vfS54EyY4cFbGDVor1E1vj3134=";
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

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
