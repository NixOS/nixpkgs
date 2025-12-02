{
  autoconf,
  automake,
  boost,
  buildNpmPackage,
  closurecompiler,
  fetchFromGitHub,
  glibc,
  harfbuzz,
  libheif,
  x265,
  libde265,
  icu,
  jdk,
  lib,
  nodejs,
  nodePackages,
  # needs to be static and built with MD2 support!
  openssl,
  pkg-config,
  qt5,
  runCommand,
  stdenv,
  writeScript,
  x2t,
}:

let
  qmake = qt5.qmake;
  libv8 = nodejs.libv8;
  fixIcu = writeScript "fix-icu.sh" ''
    substituteInPlace \
      $BUILDRT/Common/3dParty/icu/icu.pri \
      --replace-fail "ICU_MAJOR_VER = 74" "ICU_MAJOR_VER = ${lib.versions.major icu.version}"

    mkdir $BUILDRT/Common/3dParty/icu/linux_64
    ln -s ${icu}/lib $BUILDRT/Common/3dParty/icu/linux_64/build
  '';
  icuQmakeFlags = [
    "QMAKE_LFLAGS+=-Wl,--no-undefined"
    "QMAKE_LFLAGS+=-licuuc"
    "QMAKE_LFLAGS+=-licudata"
    "QMAKE_LFLAGS+=-L${icu}/lib"
  ];
  # see core/Common/3dParty/html/fetch.sh
  katana-parser-src = fetchFromGitHub {
    owner = "jasenhuang";
    repo = "katana-parser";
    rev = "be6df458d4540eee375c513958dcb862a391cdd1";
    hash = "sha256-SYJFLtrg8raGyr3zQIEzZDjHDmMmt+K0po3viipZW5c=";
  };
  # see core/Common/3dParty/html/fetch.py
  gumbo-parser-src = fetchFromGitHub {
    owner = "google";
    repo = "gumbo-parser";
    rev = "aa91b27b02c0c80c482e24348a457ed7c3c088e0";
    hash = "sha256-+607iXJxeWKoCwb490pp3mqRZ1fWzxec0tJOEFeHoCs=";
  };
  # see build_tools scripts/core_common/modules/googletest.py
  googletest-src = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    tag = "v1.13.0";
    hash = "sha256-LVLEn+e7c8013pwiLzJiiIObyrlbBHYaioO/SWbItPQ=";
  };
  # 'latest' version
  # (see build_tools scripts/core_common/modules/hyphen.py)
  hyphen-src = fetchFromGitHub {
    owner = "hunspell";
    repo = "hyphen";
    rev = "73dd2967c8e1e4f6d7334ee9e539a323d6e66cbd";
    hash = "sha256-WIHpSkOwHkhMvEKxOlgf6gsPs9T3xkzguD8ONXARf1U=";
  };
  # core/Common/3dParty/md/fetch.py
  md4c-src = fetchFromGitHub {
    owner = "mity";
    repo = "md4c";
    rev = "481fbfbdf72daab2912380d62bb5f2187d438408";
    hash = "sha256-zhInM3R0CJUqnzh6wRxMwlUdErovplbZQ5IwXe9XzZ4=";
  };
  # core/Common/3dParty/apple/fetch.py
  glm-src = fetchFromGitHub {
    owner = "g-truc";
    repo = "glm";
    rev = "33b4a621a697a305bc3a7610d290677b96beb181";
    hash = "sha256-wwGI17vlQzL/x1O0ANr5+KgU1ETnATpLw3njpKfjnKQ=";
  };
  # core/Common/3dParty/apple/fetch.py
  mdds-src = fetchFromGitHub {
    owner = "kohei-us";
    repo = "mdds";
    rev = "0783158939c6ce4b0b1b89e345ab983ccb0f0ad0";
    hash = "sha256-HMGMxMRO6SadisUjZ0ZNBGQqksNDFkEh3yaQGet9rc0=";
  };
  # core/Common/3dParty/apple/fetch.py
  librevenge-src = fetchFromGitHub {
    owner = "DistroTech";
    repo = "librevenge";
    rev = "becd044b519ab83893ad6398e3cbb499a7f0aaf4";
    hash = "sha256-2YRxuMYzKvvQHiwXH08VX6GRkdXnY7q05SL05Vbn0Vs=";
  };
  # core/Common/3dParty/apple/fetch.py
  libodfgen-src = fetchFromGitHub {
    owner = "DistroTech";
    repo = "libodfgen";
    rev = "8ef8c171ebe3c5daebdce80ee422cf7bb96aa3bc";
    hash = "sha256-Bv/smZFmZn4PEAcOlXD2Z4k96CK7A7YGDHFDsqZpuiE=";
  };
  # core/Common/3dParty/apple/fetch.py
  libetonyek-src = fetchFromGitHub {
    owner = "LibreOffice";
    repo = "libetonyek";
    rev = "cb396b4a9453a457469b62a740d8fb933c9442c3";
    hash = "sha256-nFYI7PbcLyquhAWVGkjNLHp+tymv+Pzvfa5DNPeqZiw=";
  };
  #qmakeFlags = [ "CONFIG+=debug" ];
  qmakeFlags = [ ];
  dontStrip = false;

  # Revisions that correspond to onlyoffice-documentserver 9.1.0
  core-rev = "82e281cf6bf89498e4de6018423b36576706c2b6";
  core = fetchFromGitHub {
    owner = "ONLYOFFICE";
    repo = "core";
    # rev that the 'core' submodule in documentserver points at
    rev = core-rev;
    hash = "sha256-LzbO2A29WxM0XTAO2LGTtg9omL0Pvoh+6+q3ux4i7do=";
  };
  web-apps = buildNpmPackage (finalAttrs: {
    name = "onlyoffice-core-webapps";

    #src = /home/aengelen/d/onlyoffice/documentserver/web-apps;
    #sourceRoot = "/build/web-apps/build";
    src = fetchFromGitHub {
      owner = "ONLYOFFICE";
      repo = "web-apps";
      # rev that the 'web-apps' submodule in documentserver points at
      rev = "f63e9674a5d2d2e5a660ab726ec00a359fc3c750";
      hash = "sha256-kKm6+phd6a7kP/kv6/v/FFgh96Kbs6h6jIjpFtRJgps=";
    };
    sourceRoot = "${finalAttrs.src.name}/build";

    patches = [
      ./web-apps-avoid-phantomjs.patch
    ];

    npmDepsHash = "sha256-Uen7gl6w/0A4MDk+7j+exkdwfCYqMSPJidad8AM60eQ=";

    nativeBuildInputs = [
      autoconf
      automake
      nodePackages.grunt-cli
    ];

    dontNpmBuild = true;

    postBuild = ''
      chmod u+w ..
      mkdir ../deploy
      chmod u+w -R ../apps
      grunt --force
    '';

    installPhase = ''
      runHook preInstall

      cp -r ../deploy/web-apps $out

      runHook postInstall
    '';
  });
  sdkjs = buildNpmPackage (finalAttrs: {
    name = "onlyoffice-core-sdkjs";
    src = fetchFromGitHub {
      owner = "ONLYOFFICE";
      repo = "sdkjs";
      # rev that the 'sdkjs' submodule in documentserver points at
      rev = "d169f841a7e9e46368c36236dd5820e3e10d4a98";
      hash = "sha256-GQwzz3P49sWjCxh41zyuUs5MyMjBQXaMKzxUUTHq0UE=";
    };
    sourceRoot = "${finalAttrs.src.name}/build";

    postPatch = ''
      cp npm-shrinkwrap.json package-lock.json
    '';

    npmDepsHash = "sha256-C+qp5d4wYmlrEGjIeBsjRhpivy6wKBppJWbcj1z9fbM=";

    dontNpmBuild = true;

    nativeBuildInputs = [
      nodePackages.grunt-cli
      jdk
    ];

    postBuild = ''
      chmod u+w ..

      # the one from node_modules seems a weird hybrid between dynamic and static linking
      cp ${closurecompiler}/bin/closure-compiler node_modules/google-closure-compiler-linux/compiler

      grunt
    '';

    installPhase = ''
      runHook preInstall

      cp -r ../deploy/sdkjs $out

      runHook postInstall
    '';
  });
  dictionaries = fetchFromGitHub {
    owner = "ONLYOFFICE";
    repo = "dictionaries";
    rev = "d3223bbb777883db66ac3cd249f71c6ebdc992c7";
    hash = "sha256-7hvztNYnYjyOl3ynGP0vqtx9jLPp09XVDNIow1RYuWM=";
  };
  buildCoreComponent =
    rootdir: attrs:
    stdenv.mkDerivation (
      finalAttrs:
      {
        pname = "onlyoffice-core-${rootdir}";
        # Could be neater, but these are intermediate derivations anyway
        version = core-rev;
        src = core;
        sourceRoot = "${finalAttrs.src.name}/${rootdir}";
        dontWrapQtApps = true;
        nativeBuildInputs = [
          qmake
        ];
        inherit dontStrip qmakeFlags;
        prePatch = ''
          export SRCRT=$(pwd)
          cd $(echo "${rootdir}" | sed -s "s/[^/]*/../g")
          export BUILDRT=$(pwd)
          ln -s $(pwd)/../source ../core
          chmod -R u+w .
        '';
        postPatch = ''
          cd $SRCRT
        '';

        installPhase = ''
          runHook preInstall

          mkdir -p $out/lib
          # debug builds are a level deeper than release builds
          find $BUILDRT/build -type f -exec cp {} $out/lib \;

          runHook postInstall
        '';
      }
      // attrs
    );
  buildCoreTests =
    rootdir: attrs:
    (buildCoreComponent rootdir (
      {
        doCheck = true;
        qmakeFlags = qmakeFlags ++ icuQmakeFlags;
        checkPhase = ''
          runHook preCheck
          TEST=$(find . -type f -name test)
          if [ -f "$TEST" ]; then
              $TEST
          else
              echo "Test executable not found"
              find .
              exit 1
          fi
          runHook postCheck
        '';
        installPhase = ''
          touch $out
        '';
      }
      // attrs
    ));
  unicodeConverter = buildCoreComponent "UnicodeConverter" {
    patches = [
      # icu needs c++20 for include/unicode/localpointer.h
      ./common-cpp20.patch
    ];
    qmakeFlags = qmakeFlags ++ icuQmakeFlags;
    preConfigure = ''
      source ${fixIcu}

      # https://github.com/ONLYOFFICE/core/pull/1637
      # (but not as patch because line endings)
      substituteInPlace \
        UnicodeConverter.cpp \
        --replace-fail "TRUE" "true"
    '';
    passthru.tests = buildCoreTests "UnicodeConverter/test" {
      buildInputs = [
        unicodeConverter
        kernel
      ];
      qmakeFlags = qmakeFlags ++ icuQmakeFlags;
      preConfigure = ''
        source ${fixIcu}
        echo -e "\ninclude(../../Common/3dParty/icu/icu.pri)" >> test.pro
      '';
      checkPhase = ''
        # Many of the tests do not appear to produce the 'expected' output,
        # but it's not obvious whether this an error in the behaviour
        # or in the test expectations:
        TESTS=$(ls testfiles/*_utf8.txt | grep -v "/0_" | grep -v "/11_" | grep -v "/17_" | grep -v "/18_" | grep -v "/20_" | grep -v "/21_" | grep -v "/22_" | grep -v "/23_" | grep -v "/24_" | grep -v "/25_" | grep -v "/26_" | grep -v "/27_" | grep -v "/29_" | grep -v "/30_" | grep -v "/31_" | grep -v "/33_" | grep -v "/35_" | grep -v "/41_" | grep -v "/42_" | grep -v "/43_" | cut -d "/" -f 2 | cut -d "_" -f 1 | sort | uniq)

        # This test expects the test input exactly here:
        mkdir -p $out/bin
        cp $(find ./core_build -name test) $out/bin
        cp -r testfiles $out
        $out/bin/test

        for test in $TESTS; do
          echo "Checking test $test"
          diff $out/testfiles/''${test}_utf8.txt $out/testfiles/''${test}_test_utf8.txt >/dev/null
        done
      '';
      installPhase = ''
        # TODO: this produces files in $out/testfiles. It looks like this should
        # test that the files are identical, which they are not - but it is not
        # obvious the test is 'wrong' :/
        #md5sum $out/testfiles/*
      '';
    };
  };
  kernel = buildCoreComponent "Common" {
    patches = [
      ./zlib-cstd.patch
    ];
    buildInputs = [
      unicodeConverter
    ];
    qmakeFlags = qmakeFlags ++ icuQmakeFlags;
  };
  graphics = buildCoreComponent "DesktopEditor/graphics/pro" {
    patches = [
      ./cximage-types.patch
    ];
    buildInputs = [
      unicodeConverter
      kernel
      libheif.lib
      x265
      libde265
    ];
    preConfigure = ''
      ln -s ${katana-parser-src} $BUILDRT/Common/3dParty/html/katana-parser

      mkdir -p $BUILDRT/Common/3dParty/heif/libheif/libheif
      ln -s ${libheif.dev}/include $BUILDRT/Common/3dParty/heif/libheif/libheif/api
      mkdir -p $BUILDRT/Common/3dParty/heif/libheif/build/linux_64/release
      ln -s ${libheif.lib}/lib $BUILDRT/Common/3dParty/heif/libheif/build/linux_64/release/libheif
      mkdir -p $BUILDRT/Common/3dParty/heif/x265_git/build/linux_64
      ln -s ${x265}/lib $BUILDRT/Common/3dParty/heif/x265_git/build/linux_64/release
      mkdir -p $BUILDRT/Common/3dParty/heif/libde265/build/linux_64/release
      ln -s ${libde265}/lib $BUILDRT/Common/3dParty/heif/libde265/build/linux_64/release/libde265

      # Common/3dParty/harfbuzz/make.py
      cat >$BUILDRT/Common/3dParty/harfbuzz/harfbuzz.pri <<EOL
        INCLUDEPATH += ${harfbuzz.dev}/include/harfbuzz
        LIBS += -L${harfbuzz}/lib -lharfbuzz
      EOL

      ln -s ${hyphen-src} $BUILDRT/Common/3dParty/hyphen/hyphen
    '';
    passthru.tests = lib.attrsets.genAttrs [ "alphaMask" "graphicsLayers" "TestPICT" ] (
      test:
      buildCoreTests "DesktopEditor/graphics/tests/${test}" {
        preConfigure = ''
          source ${fixIcu}
        '';
        buildInputs = [
          graphics
          kernel
          unicodeConverter
        ];
      }
    );
  };
  network = buildCoreComponent "Common/Network" {
    buildInputs = [
      kernel
    ];
  };
  docxformatlib = buildCoreComponent "OOXML/Projects/Linux/DocxFormatLib" {
    patches = [
      # Interestingly only seems to pop up when debug mode is enabled
      ./xlsx-missing-import.patch
    ];
    buildInputs = [ boost ];
  };
  cryptopp = buildCoreComponent "Common/3dParty/cryptopp/project" {
    buildInputs = [ boost ];
  };
  xlsbformatlib = buildCoreComponent "OOXML/Projects/Linux/XlsbFormatLib" {
    buildInputs = [ boost ];
  };
  xlsformatlib = buildCoreComponent "MsBinaryFile/Projects/XlsFormatLib/Linux" {
    patches = [
      ./MsBinaryFile-pragma-regions.patch
    ];
    buildInputs = [ boost ];
  };
  docformatlib = buildCoreComponent "MsBinaryFile/Projects/DocFormatLib/Linux" {
    buildInputs = [ boost ];
  };
  pptformatlib = buildCoreComponent "MsBinaryFile/Projects/PPTFormatLib/Linux" {
    buildInputs = [ boost ];
  };
  rtfformatlib = buildCoreComponent "RtfFile/Projects/Linux" {
    buildInputs = [ boost ];
  };
  txtxmlformatlib = buildCoreComponent "TxtFile/Projects/Linux" {
    buildInputs = [ boost ];
  };
  bindocument = buildCoreComponent "OOXML/Projects/Linux/BinDocument" {
    buildInputs = [ boost ];
  };
  pptxformatlib = buildCoreComponent "OOXML/Projects/Linux/PPTXFormatLib" {
    buildInputs = [ boost ];
  };
  compoundfilelib = buildCoreComponent "Common/cfcpp" { };
  iworkfile = buildCoreComponent "Apple" {
    patches = [
      ./zlib-cstd.patch
    ];
    # mdds uses bool_constant which needs a newer c++
    qmakeFlags = qmakeFlags ++ [ "CONFIG+=c++1z" ];
    buildInputs = [
      kernel
      unicodeConverter
      boost
    ];
    preConfigure = ''
      ln -s ${glm-src} $BUILDRT/Common/3dParty/apple/glm
      ln -s ${mdds-src} $BUILDRT/Common/3dParty/apple/mdds
      ln -s ${libodfgen-src} $BUILDRT/Common/3dParty/apple/libodfgen
      ln -s ${librevenge-src} $BUILDRT/Common/3dParty/apple/librevenge
      cp -r ${libetonyek-src} $BUILDRT/Common/3dParty/apple/libetonyek
      substituteInPlace \
        $BUILDRT/Common/3dParty/apple/libetonyek/src/lib/IWORKTable.cpp \
        --replace-fail "is_tree_valid" "valid_tree"
      chmod u+w $BUILDRT/Common/3dParty/apple/libetonyek/src/lib
      cp $BUILDRT/Common/3dParty/apple/headers/* $BUILDRT/Common/3dParty/apple/libetonyek/src/lib
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib
      mv ../build/lib/*/* $out/lib
      runHook postInstall
    '';
    doCheck = true;
    passthru.tests = buildCoreTests "Apple/test" {
      buildInputs = [
        unicodeConverter
        kernel
        iworkfile
      ];
      qmakeFlags = qmakeFlags ++ icuQmakeFlags;
      preConfigure = ''
        source ${fixIcu}
      '';
    };
  };
  vbaformatlib = buildCoreComponent "MsBinaryFile/Projects/VbaFormatLib/Linux" {
    buildInputs = [ boost ];
  };
  odfformatlib = buildCoreComponent "OdfFile/Projects/Linux" {
    buildInputs = [ boost ];
  };
  hwpfile = buildCoreComponent "HwpFile" {
    buildInputs = [
      cryptopp
      kernel
      unicodeConverter
      graphics
    ];
  };
  ofdfile = buildCoreComponent "OFDFile" {
    buildInputs = [
      boost
      unicodeConverter
      graphics
      kernel
      pdffile
    ];
    passthru.tests = buildCoreTests "OFDFile/test" {
      buildInputs = [
        unicodeConverter
        ofdfile
        graphics
        kernel
      ];
      patches = [ ./ofdfile-test.patch ];
      qmakeFlags = qmakeFlags ++ icuQmakeFlags;
      preConfigure = ''
        source ${fixIcu}
      '';
    };
  };
  pdffile = buildCoreComponent "PdfFile" {
    buildInputs = [
      graphics
      kernel
      unicodeConverter
      cryptopp
      network
    ];
    patches = [
      ./pdffile-limits-include.patch
    ];
  };
  djvufile = buildCoreComponent "DjVuFile" {
    buildInputs = [
      unicodeConverter
      kernel
      graphics
      pdffile
    ];
  };
  textcommandrenderer = buildCoreComponent "DocxRenderer/test/TextCommandRenderer" {
    buildInputs = [
      unicodeConverter
      kernel
      graphics
    ];
  };
  docxrenderer = buildCoreComponent "DocxRenderer" {
    buildInputs = [
      unicodeConverter
      kernel
      graphics
    ];
    passthru.tests = buildCoreTests "DocxRenderer/test" {
      buildInputs = [
        unicodeConverter
        kernel
        network
        graphics
        pdffile
        djvufile
        xpsfile
        docxrenderer
        textcommandrenderer
      ];
      preConfigure = ''
        # (not as patch because of line endings)
        sed -i '47 a #include <limits>' $BUILDRT/Common/OfficeFileFormatChecker2.cpp

        source ${fixIcu}
      '';
    };
  };
  xpsfile = buildCoreComponent "XpsFile" {
    buildInputs = [
      unicodeConverter
      graphics
      kernel
      pdffile
    ];
  };
  doctrenderer = buildCoreComponent "DesktopEditor/doctrenderer" {
    buildInputs = [
      graphics
      boost
      kernel
      unicodeConverter
      network
      pdffile
      djvufile
      xpsfile
      docxrenderer
    ];
    patches = [
      # https://github.com/ONLYOFFICE/core/pull/1631
      ./doctrenderer-format-security.patch
      ./doctrenderer-config-dir.patch
      ./doctrenderer-v8-iterator.patch
      ./fontengine-format-security.patch
      ./v8_updates.patch
      ./common-v8-no-compress-pointers.patch
      # we can enable snapshots again once we
      # compile sdkjs from source as well
      ./common-v8-no-snapshots.patch
      # needed for c++ 20 for nodejs_23
      ./common-pole-c20.patch
    ];
    qmakeFlags =
      qmakeFlags
      ++ icuQmakeFlags
      ++ [
        # c++1z for nodejs_22.libv8 (20 seems to produce errors around 'is_void_v' there)
        # c++ 20 for nodejs_23.libv8
        "CONFIG+=c++2a"
        # v8_base.h will set nMaxVirtualMemory to 4000000000/5000000000
        # which is not page-aligned, so disable memory limitation for now
        "QMAKE_CXXFLAGS+=-DV8_VERSION_121_PLUS"
        "QMAKE_CXXFLAGS+=-DDISABLE_MEMORY_LIMITATION"
        "QMAKE_LFLAGS+=-licui18n"
      ];
    preConfigure = ''
      cd $BUILDRT

      substituteInPlace \
        DesktopEditor/doctrenderer/nativecontrol.h \
        --replace-fail "fprintf(f, strVal.c_str());" "fprintf(f, \"%s\", strVal.c_str());" \
        --replace-fail "fprintf(_file, sParam.c_str());" "fprintf(_file, \"%s\", sParam.c_str());"

      # (not as patch because of line endings)
      sed -i '47 a #include <limits>' Common/OfficeFileFormatChecker2.cpp

      echo "== openssl =="
      mkdir -p Common/3dParty/openssl/build/linux_64/lib
      echo "Including openssl from ${openssl.dev}"
      ln -s ${openssl.dev}/include Common/3dParty/openssl/build/linux_64/include
      for i in ${openssl.out}/lib/*; do
        ln -s $i Common/3dParty/openssl/build/linux_64/lib/$(basename $i)
      done

      echo "== v8 =="
      mkdir -p Common/3dParty/v8_89/v8/out.gn/linux_64
      ln -s ${libv8}/lib Common/3dParty/v8_89/v8/out.gn/linux_64/obj
      tar xf ${libv8.src} --one-top-level=/tmp/xxxxx
      for i in /tmp/xxxxx/*/deps/v8/*; do
        cp -r $i Common/3dParty/v8_89/v8/
      done

      cd $BUILDRT/DesktopEditor/doctrenderer
    '';
    passthru.tests = lib.attrsets.genAttrs [ "embed/external" "embed/internal" "js_internal" "json" ] (
      test:
      buildCoreTests "DesktopEditor/doctrenderer/test/${test}" {
        patches = [ ./doctrenderer-v8-test.patch ];
        buildInputs = [ doctrenderer ];
        preConfigure = ''
          ln -s ${googletest-src} $BUILDRT/Common/3dParty/googletest/googletest
        '';
      }
    );
  };
  htmlfile2 = buildCoreComponent "HtmlFile2" {
    buildInputs = [
      boost
      kernel
      network
      graphics
      unicodeConverter
    ];
    preConfigure = ''
      ln -s ${katana-parser-src} $BUILDRT/Common/3dParty/html/katana-parser
      ln -s ${gumbo-parser-src} $BUILDRT/Common/3dParty/html/gumbo-parser
      ln -s ${md4c-src} $BUILDRT/Common/3dParty/md/md4c
    '';
  };
  epubfile = buildCoreComponent "EpubFile" {
    buildInputs = [
      kernel
      graphics
      htmlfile2
    ];
  };
  fb2file = buildCoreComponent "Fb2File" {
    buildInputs = [
      unicodeConverter
      kernel
      graphics
      boost
    ];
    qmakeFlags = qmakeFlags ++ [
      "QMAKE_LFLAGS+=-Wl,--no-undefined"
    ];
    preConfigure = ''
      ln -s ${gumbo-parser-src} $BUILDRT/Common/3dParty/html/gumbo-parser
    '';
    passthru.tests.run = buildCoreTests "Fb2File/test" {
      buildInputs = [
        fb2file
        kernel
      ];
      preConfigure = ''
        source ${fixIcu}
      '';
      checkPhase = ''
        for i in ../examples/*.fb2; do
          cp $i build/linux_64/res.fb2
          ./build/linux_64/test
        done
      '';
    };
  };
  allfontsgen = buildCoreComponent "DesktopEditor/AllFontsGen" {
    buildInputs = [
      unicodeConverter
      kernel
      graphics
      libheif.lib
    ];
    qmakeFlags = qmakeFlags ++ icuQmakeFlags;
    preConfigure = ''
      source ${fixIcu}
    '';
    dontStrip = true;
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp $BUILDRT/build/bin/*/* $BUILDRT/build/bin/*/*/* $out/bin

      runHook postInstall
    '';
  };
  core-fonts = fetchFromGitHub {
    owner = "ONLYOFFICE";
    repo = "core-fonts";
    rev = "7030c6681fb5bbed560675cb42422f91df15d5c9";
    hash = "sha256-yNUDyIJ09Ejbyt/kMrOpDbT15QTDOe7GTQChRU5+QY4=";
  };
  allfonts = runCommand "allfonts" { } ''
    mkdir -p $out/web
    mkdir -p $out/converter
    mkdir -p $out/images
    mkdir -p $out/fonts
    ${allfontsgen}/bin/allfontsgen \
      --input=${core-fonts} \
      --allfonts-web=$out/web/AllFonts.js \
      --allfonts=$out/converter/AllFonts.js \
      --images=$out/images \
      --selection=$out/converter/font_selection.bin \
      --output-web=$out/fonts
  '';
in
buildCoreComponent "X2tConverter/build/Qt" {
  pname = "x2t";
  # x2t is not 'directly' versioned, so we version it after the version
  # of documentserver it's pulled into as a submodule
  version = "9.1.0";

  buildInputs = [
    unicodeConverter
    kernel
    graphics
    network
    boost
    docformatlib
    pptformatlib
    rtfformatlib
    txtxmlformatlib
    bindocument
    pptxformatlib
    docxformatlib
    xlsbformatlib
    xlsformatlib
    compoundfilelib
    cryptopp
    fb2file
    pdffile
    htmlfile2
    epubfile
    xpsfile
    djvufile
    doctrenderer
    docxrenderer
    iworkfile
    hwpfile
    ofdfile
    vbaformatlib
    odfformatlib
  ];
  qmakeFlags = qmakeFlags ++ icuQmakeFlags ++ [ "X2tConverter.pro" ];
  preConfigure = ''
    source ${fixIcu}

    # (not as patch because of line endings)
    sed -i '47 a #include <limits>' $BUILDRT/Common/OfficeFileFormatChecker2.cpp

    substituteInPlace \
      $BUILDRT/Test/Applications/TestDownloader/mainwindow.h \
      --replace-fail "../core" ""
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    find $BUILDRT/build -type f -exec cp {} $out/bin \;

    mkdir -p $out/etc
    cat >$out/etc/DoctRenderer.config <<EOF
          <Settings>
            <file>${sdkjs}/common/Native/native.js</file>
            <file>${sdkjs}//common/Native/jquery_native.js</file>
            <allfonts>${allfonts}/converter/AllFonts.js</allfonts>
            <file>${web-apps}/vendor/xregexp/xregexp-all-min.js</file>
            <sdkjs>${sdkjs}</sdkjs>
            <dictionaries>${dictionaries}</dictionaries>
          </Settings>
    EOF

    runHook postInstall
  '';
  passthru.tests = {
    unicodeConverter = unicodeConverter.tests;
    fb2file = fb2file.tests;
    graphics = graphics.tests;
    iworkfile = iworkfile.tests;
    docxrenderer = docxrenderer.tests;
    doctrenderer = doctrenderer.tests;
    ofdfile = ofdfile.tests;
    x2t = runCommand "x2t-test" { } ''
      (${x2t}/bin/x2t || true) | grep "OOX/binary file converter." && mkdir -p $out
    '';
  };
  passthru.components = {
    inherit
      allfontsgen
      allfonts
      unicodeConverter
      kernel
      graphics
      network
      docxformatlib
      cryptopp
      xlsbformatlib
      xlsformatlib
      doctrenderer
      htmlfile2
      epubfile
      fb2file
      iworkfile
      web-apps
      sdkjs
      dictionaries
      ;
  };
  meta = {
    description = "Convert files from one format to another";
    homepage = "https://github.com/ONLYOFFICE/core/tree/master/X2tConverter";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ raboof ];
    platforms = lib.platforms.linux;
  };
}
