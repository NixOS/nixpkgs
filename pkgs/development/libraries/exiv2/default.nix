{ lib, stdenv
, fetchFromGitHub
, zlib
, expat
, cmake
, which
, libxml2
, python3
, gettext
, doxygen
, graphviz
, libxslt
, libiconv
, removeReferencesTo
}:

stdenv.mkDerivation rec {
  pname = "exiv2";
  version = "0.27.7";

  outputs = [ "out" "lib" "dev" "doc" "man" "static" ];

  src = fetchFromGitHub {
    owner = "exiv2";
    repo  = "exiv2";
    rev = "v${version}";
    sha256 = "sha256-xytVGrLDS22n2/yydFTT6CsDESmhO9mFbPGX4yk+b6g=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    gettext
    graphviz
    libxslt
    removeReferencesTo
  ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  propagatedBuildInputs = [
    expat
    zlib
  ];

  nativeCheckInputs = [
    libxml2.bin
    python3
    which
  ];

  cmakeFlags = [
    "-DEXIV2_ENABLE_NLS=ON"
    "-DEXIV2_BUILD_DOC=ON"
    "-DEXIV2_ENABLE_BMFF=ON"
  ];

  buildFlags = [
    "all"
    "doc"
  ];

  doCheck = true;

  preCheck = ''
    patchShebangs ../test/
    mkdir ../test/tmp

    ${lib.optionalString stdenv.hostPlatform.isAarch ''
      # Fix tests on arm
      # https://github.com/Exiv2/exiv2/issues/933
      rm -f ../tests/bugfixes/github/test_CVE_2018_12265.py
    ''}

    ${lib.optionalString stdenv.isDarwin ''
      export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$PWD/lib
      # Removing tests depending on charset conversion
      substituteInPlace ../test/Makefile --replace "conversions.sh" ""
      rm -f ../tests/bugfixes/redmine/test_issue_460.py
      rm -f ../tests/bugfixes/redmine/test_issue_662.py
      rm -f ../tests/bugfixes/github/test_issue_1046.py

      rm ../tests/bugfixes/redmine/test_issue_683.py

      # disable tests that requires loopback networking
      substituteInPlace  ../tests/bash_tests/testcases.py \
        --replace "def io_test(self):" "def io_disabled(self):"
     ''}
  '' + lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    export LC_ALL=C
  '' + lib.optionalString stdenv.isAarch32 ''
    # these tests are fixed in 0.28, remove when updating to 0.28
    rm -f ../tests/bugfixes/github/test_issue_1503.py
    rm -f ../tests/bugfixes/github/test_pr1475_AVIF.py
    rm -f ../tests/bugfixes/github/test_pr1475_HEIC.py
    rm -f ../tests/bugfixes/github/test_pr1475_HIF.py
  '';

  # With CMake we have to enable samples or there won't be
  # a tests target. This removes them.
  postInstall = ''
    ( cd "$out/bin"
      mv exiv2 .exiv2
      rm *
      mv .exiv2 exiv2
    )

    mkdir -p $static/lib
    mv $lib/lib/*.a $static/lib/

    remove-references-to -t ${stdenv.cc.cc} $lib/lib/*.so.*.*.* $out/bin/exiv2 $static/lib/*.a
  '';

  postFixup = ''
    substituteInPlace "$dev"/lib/cmake/exiv2/exiv2Config.cmake --replace \
      "set(_IMPORT_PREFIX \"$out\")" \
      "set(_IMPORT_PREFIX \"$static\")"
    substituteInPlace "$dev"/lib/cmake/exiv2/exiv2Config-*.cmake --replace \
      "$lib/lib/libexiv2-xmp.a" \
      "$static/lib/libexiv2-xmp.a"
  '';

  disallowedReferences = [ stdenv.cc.cc ];

  meta = with lib; {
    homepage = "https://exiv2.org";
    description = "A library and command-line utility to manage image metadata";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wegank ];
  };
}
