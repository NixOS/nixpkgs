{ stdenv, lib, fetchurl, file, glib, libxml2, libav_0_8, ffmpeg, libxslt
, mesa_noglu , xorg, alsaLib, fontconfig, freetype, pango, gtk2, cairo
, gdk_pixbuf, atk }:

# TODO: Investigate building from source instead of patching binaries.
# TODO: Binary patching for not just x86_64-linux but also x86_64-darwin i686-linux

let drv = stdenv.mkDerivation rec {
  pname = "jetbrainsjdk";
  version = "152b1036.1";
  name = pname + "-" + version;

  src = if stdenv.system == "x86_64-linux" then
    fetchurl {
      url = "https://bintray.com/jetbrains/intellij-jdk/download_file?file_path=jbsdk8u${version}_linux_x64.tar.gz";
      sha256 = "1768f02i3dxdbxn8n29d522h8v0mkgnhpb8ixzq5p54vwjmfl6md";
    }
  else
    throw "unsupported system: ${stdenv.system}";

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

  postFixup = let
    arch = "amd64";
    rSubPaths = [
      "lib/${arch}/jli"
      "lib/${arch}/server"
      "lib/${arch}/xawt"
      "lib/${arch}"
    ];
    in ''
    rpath+="''${rpath:+:}${stdenv.lib.concatStringsSep ":" (map (a: "$jrePath/${a}") rSubPaths)}"
    find $out -type f -perm -0100 \
        -exec patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "$rpath" {} \;
    find $out -name "*.so" -exec patchelf --set-rpath "$rpath" {} \;
  '';

  rpath = lib.makeLibraryPath ([
    stdenv.cc.cc stdenv.cc.libc glib libxml2 libav_0_8 ffmpeg libxslt mesa_noglu
    alsaLib fontconfig freetype pango gtk2 cairo gdk_pixbuf atk
  ] ++ (with xorg; [
    libX11 libXext libXtst libXi libXp libXt libXrender libXxf86vm
  ]));

  passthru.home = drv;

  meta = with stdenv.lib; {
    description = "An OpenJDK fork to better support Jetbrains's products.";
    longDescription = ''
     JetBrains Runtime is a runtime environment for running IntelliJ Platform
     based products on Windows, Mac OS X, and Linux. JetBrains Runtime is
     based on OpenJDK project with some modifications. These modifications
     include: Subpixel Anti-Aliasing, enhanced font rendering on Linux, HiDPI
     support, ligatures, some fixes for native crashes not presented in
     official build, and other small enhancements.

     JetBrains Runtime is not a certified build of OpenJDK. Please, use at
     your own risk.
    '';
    homepage = "https://bintray.com/jetbrains/intellij-jdk/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ edwtjo ];
    platforms = with platforms; [ "x86_64-linux" ];
  };
}; in drv
