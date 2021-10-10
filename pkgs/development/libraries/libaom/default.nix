{ lib, stdenv, fetchzip, yasm, perl, cmake, pkg-config, python3 }:

stdenv.mkDerivation rec {
  pname = "libaom";
  version = "3.1.3";

  src = fetchzip {
    url = "https://aomedia.googlesource.com/aom/+archive/v${version}.tar.gz";
    sha256 = "08rk31d2cp9k9nj37s6a4n7klpfqfbj62anwyiggzsz7b68psjq3";
    stripRoot = false;
  };

  patches = [ ./outputs.patch ];

  nativeBuildInputs = [
    yasm perl cmake pkg-config python3
  ];

  preConfigure = ''
    # build uses `git describe` to set the build version
    cat > $NIX_BUILD_TOP/git << "EOF"
    #!${stdenv.shell}
    echo v${version}
    EOF
    chmod +x $NIX_BUILD_TOP/git
    export PATH=$NIX_BUILD_TOP:$PATH
  '';

  # Configuration options:
  # https://aomedia.googlesource.com/aom/+/refs/heads/master/build/cmake/aom_config_defaults.cmake

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DENABLE_TESTS=OFF"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    # CPU detection isn't supported on Darwin and breaks the aarch64-darwin build:
    "-DCONFIG_RUNTIME_CPU_DETECT=0"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-DAS_EXECUTABLE=${stdenv.cc.targetPrefix}as"
  ] ++ lib.optionals stdenv.isAarch32 [
    # armv7l-hf-multiplatform does not support NEON
    # see lib/systems/platform.nix
    "-DENABLE_NEON=0"
  ];

  postFixup = ''
    moveToOutput lib/libaom.a "$static"
  '';

  outputs = [ "out" "bin" "dev" "static" ];

  meta = with lib; {
    description = "Alliance for Open Media AV1 codec library";
    longDescription = ''
      Libaom is the reference implementation of the AV1 codec from the Alliance
      for Open Media. It contains an AV1 library as well as applications like
      an encoder (aomenc) and a decoder (aomdec).
    '';
    homepage    = "https://aomedia.org/av1-features/get-started/";
    changelog   = "https://aomedia.googlesource.com/aom/+/refs/tags/v${version}/CHANGELOG";
    maintainers = with maintainers; [ primeos kiloreux ];
    platforms   = platforms.all;
    license = licenses.bsd2;
  };
}
