{ stdenv, pkgs, fetchurl, unzip, makeWrapper, setJavaClassPath, swingSupport ? true }:

with pkgs;

let
  version = "8.19.0.1";
  openjdk = "8.0.112";

  sha256_linux = "1icb6in1197n44wk2cqnrxr7w0bd5abxxysfrhbg56jlb9nzmp4x";
  sha256_darwin = "0kxwh62a6kckc9l9jkgakf86lqkqazp3dwfwaxqc4cg5zczgbhmd";

  platform = if stdenv.isDarwin then "macosx" else "linux";
  hash = if stdenv.isDarwin then sha256_darwin else sha256_linux;
  extension = if stdenv.isDarwin then "zip" else "tar.gz";
in stdenv.mkDerivation rec {
  inherit version openjdk platform hash extension;

  name = "zulu-${version}";

  src = fetchurl {
    url = "https://cdn.azul.com/zulu/bin/zulu${version}-jdk${openjdk}-${platform}_x64.${extension}";
    sha256 = hash;
  };

  buildInputs = [ makeWrapper ] ++ stdenv.lib.optional stdenv.isDarwin [ unzip ];

  installPhase = ''
    mkdir -p $out
    cp -r ./* "$out/"

    jrePath="$out/jre"

    rpath=$rpath''${rpath:+:}$jrePath/lib/amd64/jli
    rpath=$rpath''${rpath:+:}$jrePath/lib/amd64/server
    rpath=$rpath''${rpath:+:}$jrePath/lib/amd64/xawt
    rpath=$rpath''${rpath:+:}$jrePath/lib/amd64

    # set all the dynamic linkers
    find $out -type f -perm -0100 \
        -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$rpath" {} \;

    find $out -name "*.so" -exec patchelf --set-rpath "$rpath" {} \;

    mkdir -p $out/nix-support
    printLines ${setJavaClassPath} > $out/nix-support/propagated-native-build-inputs

    # Set JAVA_HOME automatically.
    cat <<EOF >> $out/nix-support/setup-hook
    if [ -z "\$JAVA_HOME" ]; then export JAVA_HOME=$out; fi
    EOF
  '';

  libraries = [ stdenv.cc.libc glib libxml2 libav_0_8 ffmpeg libxslt mesa_noglu xorg.libXxf86vm alsaLib fontconfig freetype gnome2.pango gnome2.gtk cairo gdk_pixbuf atk ]
      ++ (if swingSupport then [ xorg.libX11 xorg.libXext xorg.libXtst xorg.libXi xorg.libXp xorg.libXt xorg.libXrender stdenv.cc.cc ] else [ ]);

  rpath = stdenv.lib.strings.makeLibraryPath libraries;

  passthru = {
    home = "${zulu}";
  };

  meta = with stdenv.lib; {
    homepage = https://www.azul.com/products/zulu/;
    license = licenses.gpl2;
    description = "Certified builds of OpenJDK";
    longDescription = "Certified builds of OpenJDK that can be deployed across multiple operating systems, containers, hypervisors and Cloud platforms";
    maintainers = with maintainers; [ nequissimus ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
