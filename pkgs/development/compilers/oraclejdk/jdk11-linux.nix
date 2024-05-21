{ lib, stdenv
, requireFile
, xorg
, zlib
, freetype
, alsa-lib
, setJavaClassPath
}:

let result = stdenv.mkDerivation rec {
  pname = "oraclejdk";
  version = "11.0.10";

  src = requireFile {
    name = "jdk-${version}_linux-x64_bin.tar.gz";
    url = "https://www.oracle.com/java/technologies/javase-jdk11-downloads.html";
    sha256 = "94bd34f85ee38d3ef59e5289ec7450b9443b924c55625661fffe66b03f2c8de2";
  };

  installPhase = ''
    mv ../$sourceRoot $out

    mkdir -p $out/nix-support
    printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

    # Set JAVA_HOME automatically.
    cat <<EOF >> $out/nix-support/setup-hook
    if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
    EOF
  '';

  postFixup = ''
    rpath="$out/lib/jli:$out/lib/server:$out/lib:${lib.strings.makeLibraryPath [ zlib xorg.libX11 xorg.libXext xorg.libXtst xorg.libXi xorg.libXrender freetype alsa-lib]}"

    for f in $(find $out -name "*.so") $(find $out -type f -perm -0100); do
      patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$f" || true
      patchelf --set-rpath   "$rpath"                                    "$f" || true
    done

    for f in $(find $out -name "*.so") $(find $out -type f -perm -0100); do
      if ldd "$f" | fgrep 'not found'; then echo "in file $f"; fi
    done
  '';

  passthru.jre = result;
  passthru.home = result;

  dontStrip = true; # See: https://github.com/NixOS/patchelf/issues/10

  meta = with lib; {
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}; in result
