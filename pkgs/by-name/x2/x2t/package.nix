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

  src = /home/aengelen/dev/documentserver;
  #src = fetchFromGitHub {
  #  owner = "ONLYOFFICE";
  #  repo = "DocumentServer";
  #  rev = "v${finalAttrs.version}";
  #  fetchSubmodules = true;
  #  hash = "sha256-GuTDN7KLuhxW4ZHBazbW4Czi0EJoGraZd35MA7g2ElA=";
  #};
  nativeBuildInputs = [ pkg-config qt5.full ];
  buildInputs = [ gumbo boost libxml2.dev icu freetype.dev ];
  dontStrip = true;
  buildPhase = ''
    runHook preBuild

    # https://github.com/onlyOFFICE/build_tools makes many assumptions,
    # so we do things 'manually' here...

    cd core/Common/3dParty/cryptopp/project
    qmake -o Makefile cryptopp.pro
    make
    cd ../../../../..

    cd core/OOXML/Projects/Linux/XlsbFormatLib
    qmake -o Makefile XlsbFormatLib.pro
    make
    cd ../../../../..

    cd core/MsBinaryFile/Projects/XlsFormatLib/Linux
    qmake -o Makefile XlsFormatLib.pro
    make
    cd ../../../../..

    cd core/OdfFile/Projects/Linux
    qmake -o Makefile OdfFormatLib.pro
    make
    cd ../../../..

    cd core/MsBinaryFile/Projects/DocFormatLib/Linux
    qmake -o Makefile DocFormatLib.pro
    make
    cd ../../../../..

    cd core/MsBinaryFile/Projects/PPTFormatLib/Linux
    qmake -o Makefile PPTFormatLib.pro
    make
    cd ../../../../..

    cd core/RtfFile/Projects/Linux
    qmake -o Makefile RtfFormatLib.pro
    make
    cd ../../../..

    cd core/TxtFile/Projects/Linux
    qmake -o Makefile TxtXmlFormatLib.pro
    make
    cd ../../../..

    cd core/OOXML/Projects/Linux/BinDocument
    qmake -o Makefile BinDocument.pro
    make
    cd ../../../../..

    cd core/OOXML/Projects/Linux/PPTXFormatLib
    qmake -o Makefile PPTXFormatLib.pro
    make
    cd ../../../../..

    cd core/OOXML/Projects/Linux/DocxFormatLib
    qmake -o Makefile DocxFormatLib.pro
    make
    cd ../../../../..

    cd core/OOXML/Projects/Linux/XlsbFormatLib
    qmake -o Makefile XlsbFormatLib.pro
    make
    cd ../../../../..

    cd core/MsBinaryFile/Projects/XlsFormatLib/Linux
    qmake -o Makefile XlsFormatLib.pro
    make
    cd ../../../../..

    cd core/Common/cfcpp
    qmake -o Makefile cfcpp.pro
    make
    cd ../../..

    cd core/Common/3dParty/icu
    mkdir linux_64
    ln -s ${icu}/lib linux_64/build
    cd ../../../..

    # requires icu
    cd core/UnicodeConverter
    qmake -o Makefile UnicodeConverter.pro
    make
    cd ../..

    # requires UnicodeConverter
    cd core/Common
    qmake -o Makefile kernel.pro
    make
    cd ../..

    # requires kernel
    cd core/Common/Network
    qmake -o Makefile network.pro
    make
    cd ../../..

    cd core/Common/3dParty/cryptopp/project
    qmake -o Makefile cryptopp.pro
    make
    cd ../../../../..

    cd core/MsBinaryFile/Projects/VbaFormatLib/Linux
    qmake -o Makefile VbaFormatLib.pro
    make
    cd ../../../../..

    #cd core/OfficeUtils
    ##g++ -std=c++11 -c *.cpp *.c $CXXFLAGS
    #qmake OfficeUtils.pro
    #cd ../..

    cd core/Common/3dParty/html
    ln -s ${katana-parser-src} katana-parser
    cd ../../../..

    # core/Common/3dParty/harfbuzz/make.py
    cat >core/Common/3dParty/harfbuzz/harfbuzz.pri <<EOL
INCLUDEPATH += ${harfbuzz.dev}/include/harfbuzz
LIBS += -L${harfbuzz}/lib -lharfbuzz
EOL
    ln -s ${gumbo-parser-src} core/Common/3dParty/html/gumbo-parser
    ln -s ${hyphen-src} core/Common/3dParty/hyphen/hyphen

    cd core/DesktopEditor/graphics/pro
    qmake -o Makefile graphics.pro
    cat Makefile
    make
    cd ../../../..

    mkdir -p core/Common/3dParty/openssl/build/linux_64/lib
    ln -s ${openssl.dev}/include core/Common/3dParty/openssl/build/linux_64/include
    for i in ${openssl.out}/lib/*; do
      ln -s $i core/Common/3dParty/openssl/build/linux_64/lib/$(basename $i)
    done

    mkdir -p core/Common/3dParty/v8_89/v8/out.gn/linux_64
    ln -s ${v8}/lib core/Common/3dParty/v8_89/v8/out.gn/linux_64/obj
    for i in ${v8.src}/*; do
      ln -s $i core/Common/3dParty/v8_89/v8/$(basename $i)
    done

    # requires graphics, openssl (with MD2), v8
    cd core/DesktopEditor/doctrenderer
    qmake -o Makefile doctrenderer.pro
    make
    cd ../../..

    # requires UnicodeConverter, kernel, graphics
    cd core/HtmlRenderer
    qmake -o Makefile htmlrenderer.pro
    make
    cd ../..

    # depends on kernel, kernel_network, graphics and gumbo-parser
    cd core/HtmlFile2
    qmake -o Makefile HtmlFile2.pro
    make
    cd ../..

    # requires kernel, graphics and HtmlFile2
    cd core/EpubFile
    qmake -o Makefile CEpubFile.pro
    make
    cd ../..

    cd core/PdfFile
    qmake -o Makefile PdfFile.pro
    make
    cd ../..

    # requires UnicodeConverter, kernel, graphics and PdfFile
    cd core/DjVuFile
    qmake -o Makefile DjVuFile.pro
    make
    cd ../..

    # requires UnicodeConverter, graphics, kernel, PdfFile
    cd core/XpsFile
    qmake -o Makefile XpsFile.pro
    make
    cd ../..

    cd core/Fb2File
    qmake -o Makefile Fb2File.pro
    make
    cd ../..

    cd core/DocxRenderer
    qmake -o Makefile DocxRenderer.pro
    make
    cd ../..
    
    cd core/X2tConverter/build/Qt
    qmake -o Makefile X2tConverter.pro
    make
    cd ../../../..
    find .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp core/build/lib/linux_64/*.so $out/lib

    mkdir -p $out/bin
    cp core/build/bin/linux_64/x2t $out/bin

    patchelf --add-rpath ${icu}/lib $out/bin/x2t

    runHook postInstall
  '';
})
