{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, unzip
, makeWrapper
, setJavaClassPath
, zulu
# minimum dependencies
, alsaLib
, fontconfig
, freetype
, xorg
# runtime dependencies
, cups
# runtime dependencies for GTK+ Look and Feel
, gtkSupport ? stdenv.isLinux
, cairo
, glib
, gtk3
}:

let
  version = "8.48.0.53";
  openjdk = "8.0.265";

  sha256_linux = "ed32513524b32a83b3b388831c69d1884df5675bd5069c6d1485fd1a060be209";
  sha256_darwin = "36f189bfbd0255195848835819377474ba9c1c868e3c204633c451c96e21f30a";

  platform = if stdenv.isDarwin then "macosx" else "linux";
  hash = if stdenv.isDarwin then sha256_darwin else sha256_linux;
  extension = if stdenv.isDarwin then "zip" else "tar.gz";

  runtimeDependencies = [
    cups
  ] ++ lib.optionals gtkSupport [
    cairo glib gtk3
  ];
  runtimeLibraryPath = lib.makeLibraryPath runtimeDependencies;

in stdenv.mkDerivation {
  inherit version openjdk platform hash extension;

  pname = "zulu";

  src = fetchurl {
    url = "https://cdn.azul.com/zulu/bin/zulu${version}-ca-jdk${openjdk}-${platform}_x64.${extension}";
    sha256 = hash;
  };

  buildInputs = lib.optionals stdenv.isLinux [
    alsaLib # libasound.so wanted by lib/libjsound.so
    fontconfig
    freetype
    stdenv.cc.cc # libstdc++.so.6
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
  ];

  nativeBuildInputs = [
    autoPatchelfHook makeWrapper
  ] ++ lib.optionals stdenv.isDarwin [
    unzip
  ];

  installPhase = ''
    mkdir -p $out
    cp -r ./* "$out/"

    mkdir -p $out/nix-support
    printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

    # Set JAVA_HOME automatically.
    cat <<EOF >> $out/nix-support/setup-hook
    if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
    EOF
  '' + lib.optionalString stdenv.isLinux ''
    # We cannot use -exec since wrapProgram is a function but not a command.
    for bin in $( find "$out" -executable -type f ); do
      if patchelf --print-interpreter "$bin" &> /dev/null; then
        wrapProgram "$bin" --prefix LD_LIBRARY_PATH : "${runtimeLibraryPath}"
      fi
    done
  '';

  preFixup = ''
    find "$out" -name libfontmanager.so -exec \
      patchelf --add-needed libfontconfig.so {} \;
  '';

  passthru = {
    home = zulu;
  };

  meta = with lib; {
    homepage = "https://www.azul.com/products/zulu/";
    license = licenses.gpl2;
    description = "Certified builds of OpenJDK";
    longDescription = ''
      Certified builds of OpenJDK that can be deployed across multiple
      operating systems, containers, hypervisors and Cloud platforms.
    '';
    maintainers = with maintainers; [ fpletz ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
