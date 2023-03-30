{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, glibcLocales
, perl
, qmake
, qtbase
, qtdeclarative
, withExamples ? true
, wrapQtAppsHook
, xvfb-run
}:

stdenv.mkDerivation rec {
  pname = "qtpim";
  version = "unstable-2020-11-02";

  src = fetchFromGitHub {
    owner = "qt";
    repo = "qtpim";
    # Last commit before Qt5 support was broken
    rev = "f9a8f0fc914c040d48bbd0ef52d7a68eea175a98";
    hash = "sha256-/1g+vvHjuRLB1vsm41MrHbBZ+88Udca0iEcbz0Q1BNQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    ## Upstream patches after the Qt6 transition that apply without problems & fix bugs

    # Fixes QList -> QSet conversion
    (fetchpatch {
      url = "https://github.com/qt/qtpim/commit/f337e281e28904741a3b1ac23d15c3a83ef2bbc9.patch";
      hash = "sha256-zlxD45JnbhIgdJxMmGxGMUBcQPcgzpu3s4bLX939jL0=";
    })
    # Fixes invalid syntax from a previous bad patch in tests
    (fetchpatch {
      url = "https://github.com/qt/qtpim/commit/2aefdd8bd28a4decf9ef8381f5b255f39f1ee90c.patch";
      hash = "sha256-mg93QF3hi50igw1/Ok7fEs9iCaN6co1+p2/5fQtxTmc=";
    })
    # Unit test account for QList index change
    (fetchpatch {
      url = "https://github.com/qt/qtpim/commit/79b41af6a4117f5efb0298289e20c30b4d0b0b2e.patch";
      hash = "sha256-u+cLl4lu6r2+j5GAiasqbB6/OZPz5A6GpSB33vd/VBg=";
    })
    # Remove invalid method overload which confuses the QML engine
    (fetchpatch {
      url = "https://github.com/qt/qtpim/commit/5679a6141c76ae7d64c3acc8a87b1adb048289e0.patch";
      hash = "sha256-z8f8kLhC9CqBOfGPL8W9KJq7MwALAAicXfRkHiQEVJ4=";
    })
    # Specify enum flag type properly in unit test
    (fetchpatch {
      url = "https://github.com/qt/qtpim/commit/a43cc24e57db8d3c3939fa540d67da3294dcfc5c.patch";
      hash = "sha256-SsYkxX6prxi8VRZr4az+wqawcRN8tR3UuIFswJL+3T4=";
    })
    # Update qHash methods to return size_t instead of uint
    (fetchpatch {
      url = "https://github.com/qt/qtpim/commit/9c698155d82fc2b68a87c59d0443c33f9085b117.patch";
      hash = "sha256-rb8D8taaglhQikYSAPrtLvazgIw8Nga/a9+J21k8gIo=";
    })
    # Mark virtual methods with override keyword
    (fetchpatch {
      url = "https://github.com/qt/qtpim/commit/f34cf2ff2b0f428d5b8a70763b29088075ebbd1c.patch";
      hash = "sha256-tNPOEVpx1eqHx5T23ueW32KxMQ/SB+TBCJ4PZ6SA3LI=";
    })
    # Fix calendardemo example
    (fetchpatch {
      url = "https://github.com/qt/qtpim/commit/a66590d473753bc49105d3132fb9e4150c92a14a.patch";
      hash = "sha256-RPRtGQ24NQYewnv6+IqYITpwD/XxuK68a1iKgFmKm3c=";
    })
    # Make the tests pass on big endian systems
    (fetchpatch {
      url = "https://github.com/qt/qtpim/commit/7802f038ed1391078e27fa3f37d785a69314537b.patch";
      hash = "sha256-hogUXyPXjGE0q53PWOjiQbQ2YzOsvrJ7mo9djGIbjVQ=";
    })
    # Fix some deprecated QChar constructor issues in unit tests
    (fetchpatch {
      url = "https://github.com/qt/qtpim/commit/114615812dcf9398c957b0833e860befe15f840f.patch";
      hash = "sha256-yZ1qs8y5DSq8FDXRPyuSPRIzjEUTWAhpVide/b+xaLQ=";
    })
    # Accessors should be const
    (fetchpatch {
      url = "https://github.com/qt/qtpim/commit/a2bf7cdf05c264b5dd2560f799760b5508f154e4.patch";
      hash = "sha256-+YfPrKyOKnPkqFokwW/aDsEivg4TzdJwQpDdAtM+rQE=";
    })
    # Enforce detail access constraints in contact operations by default
    (fetchpatch {
      url = "https://github.com/qt/qtpim/commit/8765a35233aa21a932ee92bbbb92a5f8edd4dc68.patch";
      hash = "sha256-vp/enerVecEXz4zyxQ66DG+fVVWxI4bYnLj92qaaqNk=";
    })
    # Fixes broken file generation, which breaks reverse dependencies that try to find one of its modules
    (fetchpatch {
      url = "https://github.com/qt/qtpim/commit/4b2bdce30bd0629c9dc0567af6eeaa1d038f3152.patch";
      hash = "sha256-2dXhkZyxPvY2KQq2veerAlpXkpU5/FeArWRlm1aOcEY=";
    })

    ## Patches that haven't been upstreamed

    # Fix tst_QContactManager::compareVariant_data test
    (fetchpatch {
      url = "https://salsa.debian.org/qt-kde-team/qt/qtpim/-/raw/360682f88457b5ae7c92f32f574e51ccc5edbea0/debian/patches/1001_fix-qtdatetime-null-comparison.patch";
      hash = "sha256-k/rO9QjwSlRChwFTZLkxDjZWqFkua4FNbaNf1bJKLxc=";
    })
    # Avoid crash while parsing vCards from different threads
    (fetchpatch {
      url = "https://salsa.debian.org/qt-kde-team/qt/qtpim/-/raw/360682f88457b5ae7c92f32f574e51ccc5edbea0/debian/patches/1002_Avoid-crash-while-parsing-vcards-from-different-threads.patch";
      hash = "sha256-zhayAoWgcmKosEGVBy2k6a2e6BxyVwfGX18tBbzqEk8=";
    })
    # Adapt to JSON parser behavior change in Qt 5.15
    (fetchpatch {
      url = "https://salsa.debian.org/qt-kde-team/qt/qtpim/-/raw/360682f88457b5ae7c92f32f574e51ccc5edbea0/debian/patches/1003_adapt_to_json_parser_change.patch";
      hash = "sha256-qAIa48hmDd8vMH/ywqW+22vISKai76XnjgFuB+tQbIU=";
    })
    # Fix version being 0.0.0
    (fetchpatch {
      url = "https://salsa.debian.org/qt-kde-team/qt/qtpim/-/raw/360682f88457b5ae7c92f32f574e51ccc5edbea0/debian/patches/2000_revert_module_version.patch";
      hash = "sha256-6wg/eVu9J83yvIO428U1FX3otz58tAy6pCvp7fqOBKU=";
    })
  ];

  postPatch = ''
    # Too many & too much nesting to explicitly list them all
    for example_pro in $(find examples -name '*.pro'); do
      substituteInPlace $example_pro \
        --replace '$$[QT_INSTALL_EXAMPLES]' "$dev/share/examples"
    done
  '';

  strictDeps = true;

  nativeBuildInputs = [
    perl
    qmake
    qtdeclarative # QMake cannot find it in buildInputs
  ] ++ lib.optionals withExamples [
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [
    glibcLocales
    xvfb-run
  ];

  qmakeFlags = [
    "CONFIG+=git_build"
  ] ++ lib.optionals withExamples [
    "QT_BUILD_PARTS+=examples"
  ] ++ lib.optionals doCheck [
    "QT_BUILD_PARTS+=tests"
  ];

  dontWrapQtApps = true;

  # Might be flaky & get stuck until timeout sometimes?
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck

    export LC_ALL=en_US.UTF-8
    export QML2_IMPORT_PATH=$PWD/qml
    export QT_PLUGIN_PATH=$PWD/plugins
    export LD_LIBRARY_PATH=$PWD/lib
    xvfb-run -s '-screen 0 800x600x24' make check

    runHook postCheck
  '';

  postFixup = lib.optionalString withExamples ''
    # Examples are not in a path where automatic wrapQtAppsHook can find them
    for example in $(find $dev -type f -executable); do
      wrapQtApp $example
    done
  '';

  meta = with lib; {
    description = "Qt Personal Information Management";
    homepage = "https://github.com/qt/qtpim";
    license = with licenses; [ lgpl3Only /* or */ gpl2Plus ];
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}
