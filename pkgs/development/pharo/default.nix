{ cairo
, cmake
, fetchurl
, freetype
, gcc
, git
, gnumake
, lib
, libffi
, libgit2
, libpng
, libuuid
, makeBinaryWrapper
, openssl
, pixman
, runtimeShell
, SDL2
, stdenv
, unzip
}:
let
  inherit (lib.strings) makeLibraryPath;
  pharo-sources = fetchurl {
    # It is necessary to download from there instead of from the repository because that archive
    # also contains artifacts necessary for the bootstrapping.
    url = "https://files.pharo.org/vm/pharo-spur64-headless/Linux-x86_64/source/PharoVM-10.0.5-2757766-Linux-x86_64-c-src.zip";
    hash = "sha256-i6WwhdVdyzmqGlx1Fn12mCq5+HnRORT65HEiJo0joCE=";
  };
  library_path = makeLibraryPath [
    libgit2
    SDL2
    cairo
    "$out"
  ];
in
stdenv.mkDerivation {
  pname = "pharo";
  version = "10.0.5";
  src = pharo-sources;

  buildInputs = [
    cairo
    libgit2
    libpng
    pixman
    SDL2
  ];

  nativeBuildInputs = [
    cmake
    freetype
    gcc
    git
    gnumake
    libffi
    libuuid
    makeBinaryWrapper
    openssl
    pixman
    SDL2
    unzip
  ];

  cmakeFlags = [
    # Necessary to perform the bootstrapping without already having Pharo available.
    "-DGENERATED_SOURCE_DIR=."
    "-DGENERATE_SOURCES=OFF"
    # Prevents CMake from trying to download stuff.
    "-DBUILD_BUNDLE=OFF"
  ];

  installPhase = ''
    runHook preInstall

    cmake --build . --target=install
    mkdir -p "$out/lib"
    mkdir "$out/bin"
    cp build/vm/*.so* "$out/lib/"
    cp build/vm/pharo "$out/bin/pharo"
    patchelf --allowed-rpath-prefixes "$NIX_STORE" --shrink-rpath "$out/bin/pharo"
    wrapProgram "$out/bin/pharo" --set LD_LIBRARY_PATH "${library_path}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Clean and innovative Smalltalk-inspired environment";
    homepage = "https://pharo.org";
    license = licenses.mit;
    longDescription = ''
      Pharo's goal is to deliver a clean, innovative, free open-source
      Smalltalk-inspired environment. By providing a stable and small core
      system, excellent dev tools, and maintained releases, Pharo is an
      attractive platform to build and deploy mission critical applications.
    '';
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
