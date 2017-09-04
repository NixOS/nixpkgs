{ stdenv, fetchurl, file, glib, libxml2, libav_0_8, ffmpeg, libxslt, mesa_noglu,
 xorg, alsaLib, fontconfig, freetype, pango, gtk2, cairo, gdk_pixbuf, atk }:

let
  version = "152b970.2";
  architecture = "amd64";
  rSubPaths = [
    "lib/${architecture}/jli"
    "lib/${architecture}/server"
    "lib/${architecture}/xawt"
    "lib/${architecture}"
  ];
  libraries =
    [stdenv.cc.libc glib libxml2 libav_0_8 ffmpeg libxslt mesa_noglu xorg.libXxf86vm alsaLib fontconfig freetype pango gtk2 cairo gdk_pixbuf atk] ++
    [xorg.libX11 xorg.libXext xorg.libXtst xorg.libXi xorg.libXp xorg.libXt xorg.libXrender stdenv.cc.cc];

in

let jbsdk = stdenv.mkDerivation {
  name = "jbsdk-${version}";
  src = fetchurl {
    url = "https://bintray.com/jetbrains/intellij-jdk/download_file?file_path=jbsdk8u${version}_linux_x64.tar.gz";
    sha256 = "0i2cqjfab91kr618z88nb5g9yg60j5z08wjl0nlvcmpvg2z6va0m";
  };
  nativeBuildInputs = [ file ];

  unpackCmd = "mkdir jdk; pushd jdk; tar -xzf $src; popd";

  installPhase = ''
    cd ..

    exes=$(file $sourceRoot/bin/* $sourceRoot/jre/bin/* 2> /dev/null | grep -E 'ELF.*(executable|shared object)' | sed -e 's/: .*$//')
    for file in $exes; do
      paxmark m "$file"
    done

    mv $sourceRoot $out
    jrePath=$out/jre
  '';

  postFixup = ''
    rpath+="''${rpath:+:}${stdenv.lib.concatStringsSep ":" (map (a: "$jrePath/${a}") rSubPaths)}"
    find $out -type f -perm -0100 \
        -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$rpath" {} \;
    find $out -name "*.so" -exec patchelf --set-rpath "$rpath" {} \;
  '';


  rpath = stdenv.lib.strings.makeLibraryPath libraries;

  passthru.home = jbsdk;
}; in jbsdk
