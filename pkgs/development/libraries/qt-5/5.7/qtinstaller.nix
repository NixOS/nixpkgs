{ qtSubmodule, fetchurl, qtdeclarative , qttools, mirror }:

qtSubmodule {
  name = "qtinstaller";
  qtInputs = [ qtdeclarative qttools ];
  version = "2.0.3";
  src = fetchurl {
      url = "${mirror}/official_releases/qt-installer-framework/2.0.3/qt-installer-framework-opensource-2.0.3-src.tar.gz";
      sha256 = "003gwjg02isw8qjyka377g1ahlisfyi44l6xfa4hvvdgqqq0hy2f";
      name = "qt-installer-framework-opensource-src-2.0.3.tar.gz";
  };

  outputs = [ "out" "dev" "doc" ];

  installPhase = ''
    mkdir -p $out/{bin,lib,share/qt-installer-framework}
    cp -a bin/{archivegen,binarycreator,devtool,installerbase,repogen} $out/bin
    cp -a lib/{libinstaller.so*,lib7z.a} $out/lib
    cp -a examples $out/share/qt-installer-framework/
  '';

  postFixup = ''
    moveToOutput "bin/archivegen" "$out"
    moveToOutput "bin/binarycreator" "$out"
    moveToOutput "bin/devtool" "$out"
    moveToOutput "bin/installerbase" "$out"
    moveToOutput "bin/repogen" "$out"
    moveToOutput "share" "$doc"
    moveToOutput "lib/libinstaller.so" "$out"
    moveToOutput "lib/libinstaller.so.1" "$out"
    moveToOutput "lib/libinstaller.so.1.0" "$out"
    moveToOutput "lib/libinstaller.so.1.0.0" "$out"
  '';
}
