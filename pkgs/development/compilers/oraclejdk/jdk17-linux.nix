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
  version = "17.0.3.1";

  src = requireFile {
    name = "jdk-${version}_linux-x64_bin.tar.gz";
    url = "https://www.oracle.com/java/technologies/downloads/#java17";
    sha256 = "1lwwksdpqw4j45mlp8s745y69cy6ndx20bwycni83yr1v96z9my5";
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
    rpath="$out/lib/jli:$out/lib/server:$out/lib:${lib.strings.makeLibraryPath [ stdenv.cc.cc zlib xorg.libX11 xorg.libXext xorg.libXtst xorg.libXi xorg.libXrender freetype alsa-lib]}"

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
