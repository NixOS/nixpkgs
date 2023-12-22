{ stdenv
, lib
, fetchurl
, makeBinaryWrapper
, cmake
, cairo
, freetype
, libffi
, libgit2
, libpng
, libuuid
, openssl
, pixman
, SDL2
}:

let
  inherit (lib.strings) makeLibraryPath;
  pharoVm = "PharoVM-10.0.9-de76067";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "pharo";
    version = "10.0.9";
    src = fetchurl {
      # It is necessary to download from there instead of from the repository because that archive
      # also contains artifacts necessary for the bootstrapping.
      url = "https://files.pharo.org/vm/pharo-spur64-headless/Linux-x86_64/source/${pharoVm}-Linux-x86_64-c-src.tar.gz";
      hash = "sha256-55ezsAvjj70Vj/unMtF1MH/pkoQhUp4fW5ap5VPwGL8=";
    };

    buildInputs = [
      cairo
      freetype
      libffi
      libgit2
      libpng
      libuuid
      openssl
      pixman
      SDL2
    ];

    nativeBuildInputs = [ cmake makeBinaryWrapper ];

    dontPatchELF = true;

    cmakeFlags = [
      # Necessary to perform the bootstrapping without already having Pharo available.
      "-DGENERATED_SOURCE_DIR=."
      "-DALWAYS_INTERACTIVE=ON"
      "-DBUILD_IS_RELEASE=ON"
      "-DGENERATE_SOURCES=OFF"
      # Prevents CMake from trying to download stuff.
      "-DBUILD_BUNDLE=OFF"
    ];

    installPhase = ''
      runHook preInstall

      cmake --build . --target=install
      mkdir -p "$out/lib" "$out/bin"
      cp build/vm/*.so* "$out/lib/"
      cp build/vm/pharo "$out/bin/pharo"

      runHook postInstall
    '';

    preFixup = let
      libPath = lib.makeLibraryPath (finalAttrs.buildInputs ++ [
        stdenv.cc.cc.lib
        "$out"
      ]);
    in ''
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/bin/pharo
      patchelf --shrink-rpath $out/bin/pharo
      patchelf --set-rpath "${libPath}" $out/lib/*.so
      patchelf --shrink-rpath $out/lib/*.so

      patchelf --set-rpath "${libPath}" $out/lib/libPharoVMCore.so
      ln -s "${libgit2}/lib/libgit2.so" $out/lib/libgit2.so.1.1
      wrapProgram "$out/bin/pharo" --argv0 $out/bin/pharo --prefix LD_LIBRARY_PATH ":" "${libPath}"
    '';

    meta = {
      description = "Clean and innovative Smalltalk-inspired environment";
      homepage = "https://pharo.org";
      license = lib.licenses.mit;
      longDescription = ''
        Pharo's goal is to deliver a clean, innovative, free open-source
        Smalltalk-inspired environment. By providing a stable and small core
        system, excellent dev tools, and maintained releases, Pharo is an
        attractive platform to build and deploy mission critical applications.
      '';
      mainProgram = "pharo";
      maintainers = with lib.maintainers; [ suhr ];
      platforms = [ "x86_84-linux" ];
    };
  })
