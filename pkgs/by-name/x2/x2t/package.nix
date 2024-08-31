{ 
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libxml2,
  boost,
  gumbo,
  icu,
  freetype,
  qt5,
  harfbuzz,
  # needs to be static and built with MD2 support!
  openssl,
  # should find out if newer versions work...
  v8,
}:

let
  # see core/Common/3dParty/fetch.sh
  katana-parser-src = fetchFromGitHub {
    owner = "jasenhuang";
    repo = "katana-parser";
    rev = "be6df458d4540eee375c513958dcb862a391cdd1";
    hash = "sha256-SYJFLtrg8raGyr3zQIEzZDjHDmMmt+K0po3viipZW5c=";
  };
  # see build_tools scripts/core_common/modules/hyphen.py
  hyphen-src = fetchFromGitHub {
    owner = "hunspell";
    repo = "hyphen";
    rev = "73dd2967c8e1e4f6d7334ee9e539a323d6e66cbd";
    hash = "sha256-WIHpSkOwHkhMvEKxOlgf6gsPs9T3xkzguD8ONXARf1U=";
  };
  # see core/Common/3dParty/html/fetch.py
  gumbo-parser-src = fetchFromGitHub {
    owner = "google";
    repo = "gumbo-parser";
    rev = "aa91b27b02c0c80c482e24348a457ed7c3c088e0";
    hash = "sha256-+607iXJxeWKoCwb490pp3mqRZ1fWzxec0tJOEFeHoCs=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "x2t";
  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "ONLYOFFICE";
    repo = "core";
    # corresponds to documentserver 8.1.1
    rev = "90d46b55d8d10814f961661f815189e16d2271b9";
    hash = "sha256-1gH3AFYE4v21+3C4QKboHKaP0XmEN7gr1lG8+pT4SC4=";
  };
  patchFlags = [ "-p1" "-l" ];
  patches = [
    # https://github.com/ONLYOFFICE/core/pull/1631
    ./doctrenderer-format-security.patch
    ./fontengine-format-security.patch
    # Not sure what's going on here...
    ./MsBinaryFile-pragma-regions.patch
    # Interestingly only seems to pop up when debug mode is enabled
    ./xlsx-missing-import.patch
  ];

  nativeBuildInputs = [ pkg-config qt5.full ];
  buildInputs = [ gumbo boost libxml2.dev icu freetype.dev ];
  dontStrip = true;
  buildPhase = ''
    runHook preBuild

    # https://github.com/onlyOFFICE/build_tools makes many assumptions,
    # so we do things 'manually' here...

    substituteInPlace \
      Common/3dParty/icu/icu.pri \
      --replace-fail "ICU_MAJOR_VER = 58" "ICU_MAJOR_VER = 74"

    # https://github.com/ONLYOFFICE/core/pull/1637
    # (but not as patch because line endings)
    substituteInPlace \
      UnicodeConverter/UnicodeConverter.cpp \
      --replace-fail "TRUE" "true"

    substituteInPlace \
      DesktopEditor/doctrenderer/nativecontrol.h \
      --replace-fail "fprintf(f, strVal.c_str());" "fprintf(f, \"%s\", strVal.c_str());" \
      --replace-fail "fprintf(_file, sParam.c_str());" "fprintf(_file, \"%s\", sParam.c_str());"

    echo "== DocxFormatLib =="
    cd OOXML/Projects/Linux/DocxFormatLib
    qmake "CONFIG+=debug" -o Makefile DocxFormatLib.pro
    make
    cd ../../../..

    echo "== cryptopp =="
    cd Common/3dParty/cryptopp/project
    qmake -o Makefile cryptopp.pro
    make
    cd ../../../..

    echo "== XlsbFormatLib =="
    cd OOXML/Projects/Linux/XlsbFormatLib
    qmake -o Makefile XlsbFormatLib.pro
    make
    cd ../../../..

    echo "== MsBinaryFile =="
    cd MsBinaryFile/Projects/XlsFormatLib/Linux
    qmake -o Makefile XlsFormatLib.pro
    make
    cd ../../../..

    echo "== OdfFile =="
    cd OdfFile/Projects/Linux
    qmake -o Makefile OdfFormatLib.pro
    make
    cd ../../..

    echo "== DocFormatLib =="
    cd MsBinaryFile/Projects/DocFormatLib/Linux
    qmake "CONFIG+=debug" -o Makefile DocFormatLib.pro
    make
    cd ../../../..

    echo "== PPTFormatLib =="
    cd MsBinaryFile/Projects/PPTFormatLib/Linux
    qmake -o Makefile PPTFormatLib.pro
    make
    cd ../../../..

    echo "== RtfFile =="
    cd RtfFile/Projects/Linux
    qmake -o Makefile RtfFormatLib.pro
    make
    cd ../../..

    echo "== TxtFile =="
    cd TxtFile/Projects/Linux
    qmake -o Makefile TxtXmlFormatLib.pro
    make
    cd ../../..

    echo "== BinDocument =="
    cd OOXML/Projects/Linux/BinDocument
    qmake "CONFIG+=debug" -o Makefile BinDocument.pro
    make
    cd ../../../..

    echo "== PPTXFormatLib =="
    cd OOXML/Projects/Linux/PPTXFormatLib
    qmake -o Makefile PPTXFormatLib.pro
    make
    cd ../../../..

    echo "== XlsbFormatLib =="
    cd OOXML/Projects/Linux/XlsbFormatLib
    qmake -o Makefile XlsbFormatLib.pro
    make
    cd ../../../..

    echo "== XlsFormatLib =="
    cd MsBinaryFile/Projects/XlsFormatLib/Linux
    qmake -o Makefile XlsFormatLib.pro
    make
    cd ../../../..

    echo "== cfcpp =="
    cd Common/cfcpp
    qmake -o Makefile cfcpp.pro
    make
    cd ../..

    echo "== icu =="
    cd Common/3dParty/icu
    mkdir linux_64
    ln -s ${icu}/lib linux_64/build
    cd ../../..

    echo "== UnicodeConverter =="
    # requires icu
    cd UnicodeConverter
    qmake -o Makefile UnicodeConverter.pro
    make
    cd ..

    # requires UnicodeConverter
    echo "== kernel =="
    cd Common
    qmake -o Makefile kernel.pro
    make
    cd ..

    echo "== kernel_network =="
    # requires kernel
    cd Common/Network
    qmake -o Makefile network.pro
    make
    cd ../..

    echo "== VbaFormatLib =="
    cd MsBinaryFile/Projects/VbaFormatLib/Linux
    qmake -o Makefile VbaFormatLib.pro
    make
    cd ../../../..

    echo "== katana-parser =="
    cd Common/3dParty/html
    ln -s ${katana-parser-src} katana-parser
    cd ../../..

    echo "== harfbuzz =="
    # Common/3dParty/harfbuzz/make.py
    cat >Common/3dParty/harfbuzz/harfbuzz.pri <<EOL
INCLUDEPATH += ${harfbuzz.dev}/include/harfbuzz
LIBS += -L${harfbuzz}/lib -lharfbuzz
EOL
    ln -s ${gumbo-parser-src} Common/3dParty/html/gumbo-parser
    ln -s ${hyphen-src} Common/3dParty/hyphen/hyphen

    echo "== graphics =="
    cd DesktopEditor/graphics/pro
    qmake -o Makefile graphics.pro
    cat Makefile
    make
    cd ../../..

    echo "== openssl =="
    mkdir -p Common/3dParty/openssl/build/linux_64/lib
    ln -s ${openssl.dev}/include Common/3dParty/openssl/build/linux_64/include
    for i in ${openssl.out}/lib/*; do
      ln -s $i Common/3dParty/openssl/build/linux_64/lib/$(basename $i)
    done

    echo "== v8 =="
    mkdir -p Common/3dParty/v8_89/v8/out.gn/linux_64
    ln -s ${v8}/lib Common/3dParty/v8_89/v8/out.gn/linux_64/obj
    for i in ${v8.src}/*; do
      ln -s $i Common/3dParty/v8_89/v8/$(basename $i)
    done

    echo "== doctrenderer =="
    # requires graphics, openssl (with MD2), v8
    cd DesktopEditor/doctrenderer
    qmake -o Makefile doctrenderer.pro
    make
    cd ../..

    echo "== HtmlRenderer =="
    # requires UnicodeConverter, kernel, graphics
    cd HtmlRenderer
    qmake -o Makefile htmlrenderer.pro
    make
    cd ..

    echo "== HtmlFile2 =="
    # depends on kernel, kernel_network, graphics and gumbo-parser
    cd HtmlFile2
    qmake -o Makefile HtmlFile2.pro
    make
    cd ..

    echo "== EpubFile =="
    # requires kernel, graphics and HtmlFile2
    cd EpubFile
    qmake -o Makefile CEpubFile.pro
    make
    cd ..

    echo "== PdfFile =="
    cd PdfFile
    qmake -o Makefile PdfFile.pro
    make
    cd ..

    echo "== DjVuFile =="
    # requires UnicodeConverter, kernel, graphics and PdfFile
    cd DjVuFile
    qmake -o Makefile DjVuFile.pro
    make
    cd ..

    echo "== XpsFile =="
    # requires UnicodeConverter, graphics, kernel, PdfFile
    cd XpsFile
    qmake -o Makefile XpsFile.pro
    make
    cd ..

    echo "== Fb2File =="
    cd Fb2File
    qmake -o Makefile Fb2File.pro
    make
    cd ..

    echo "== DocxRenderer =="
    cd DocxRenderer
    qmake "CONFIG+=debug" -o Makefile DocxRenderer.pro
    make
    cd ..
    
    echo "== X2tConverter =="
    cd X2tConverter/build/Qt
    qmake "CONFIG+=debug" -o Makefile X2tConverter.pro
    make
    cd ../../..
    find .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp build/lib/linux_64/*.so $out/lib

    mkdir -p $out/bin
    cp build/bin/linux_64/x2t $out/bin

    patchelf --add-rpath ${icu}/lib $out/bin/x2t

    runHook postInstall
  '';
})
