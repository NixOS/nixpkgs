{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, unzip
, makeWrapper
, setJavaClassPath
, zulu
# minimum dependencies
, alsa-lib
, fontconfig
, freetype
, zlib
, xorg
# runtime dependencies
, cups
# runtime dependencies for GTK+ Look and Feel
, gtkSupport ? stdenv.isLinux
, cairo
, glib
, gtk3 }:

let
  version = "19.32.13";
  openjdk = "19.0.2";

  sha256_x64_linux = "sha256-SplK3tHZs1JY1UOlnUlj0mh6EJSoGLeaIfACc/u8W8o=";
  sha256_aarch64_linux = "sha256-diFu+mnkSP5IfVcxA3KuoN8c8VuCl0yEqMsNl+uTQWU=";
  sha256_x64_darwin = "sha256-KARXWumsY+OcqpEOV2EL9SsPni1nGSipjRji/Mn2KsE=";
  sha256_aarch64_darwin = "sha256-F30FjZaLL756X/Xs6xjNwW9jds4pEATxoxOeeLL7Y5E=";

  platform = if stdenv.isDarwin then "macosx" else "linux";
  hash = if stdenv.isAarch64 && stdenv.isDarwin then
    sha256_aarch64_darwin
  else if stdenv.isDarwin then
    sha256_x64_darwin
  else if stdenv.isAarch64 then
    sha256_aarch64_linux
  else
    sha256_x64_linux;
  extension = "tar.gz";
  architecture = if stdenv.isAarch64 then "aarch64" else "x64";

  runtimeDependencies = [ cups ]
    ++ lib.optionals gtkSupport [ cairo glib gtk3 ];
  runtimeLibraryPath = lib.makeLibraryPath runtimeDependencies;

in stdenv.mkDerivation {
  inherit version openjdk platform hash extension;

  pname = "zulu";

  src = fetchurl {
    url =
      "https://cdn.azul.com/zulu/bin/zulu${version}-ca-jdk${openjdk}-${platform}_${architecture}.${extension}";
    sha256 = hash;
  };

  buildInputs = lib.optionals stdenv.isLinux [
    alsa-lib # libasound.so wanted by lib/libjsound.so
    fontconfig
    freetype
    stdenv.cc.cc # libstdc++.so.6
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    zlib
  ];

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ]
    ++ lib.optionals stdenv.isDarwin [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./* "$out/"
  '' + lib.optionalString stdenv.isLinux ''
    # jni.h expects jni_md.h to be in the header search path.
    ln -s $out/include/linux/*_md.h $out/include/
  '' + ''
    mkdir -p $out/nix-support
    printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

    # Set JAVA_HOME automatically.
    cat <<EOF >> $out/nix-support/setup-hook
    if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
    EOF
  '' + lib.optionalString stdenv.isLinux ''
    # We cannot use -exec since wrapProgram is a function but not a command.
    #
    # jspawnhelper is executed from JVM, so it doesn't need to wrap it, and it
    # breaks building OpenJDK (#114495).
    for bin in $( find "$out" -executable -type f -not -name jspawnhelper ); do
      wrapProgram "$bin" --prefix LD_LIBRARY_PATH : "${runtimeLibraryPath}"
    done
  '' + ''
    runHook postInstall
  '';

  preFixup = ''
    find "$out" -name libfontmanager.so -exec \
      patchelf --add-needed libfontconfig.so {} \;
  '';

  passthru = { home = zulu; };

  meta = with lib; {
    homepage = "https://www.azul.com/products/zulu/";
    sourceProvenance = with sourceTypes; [ binaryBytecode binaryNativeCode ];
    license = licenses.gpl2;
    description = "Certified builds of OpenJDK";
    longDescription = ''
      Certified builds of OpenJDK that can be deployed across multiple
      operating systems, containers, hypervisors and Cloud platforms.
    '';
    maintainers = with maintainers; [ ];
    platforms =
      [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
    mainProgram = "java";
  };
}
