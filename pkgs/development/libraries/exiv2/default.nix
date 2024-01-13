{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, doxygen
, gettext
, graphviz
, libxslt
, removeReferencesTo
, libiconv
, brotli
, expat
, inih
, zlib
, libxml2
, python3
, which
}:

stdenv.mkDerivation rec {
  pname = "exiv2";
  version = "0.28.1";

  outputs = [ "out" "lib" "dev" "doc" "man" ];

  src = fetchFromGitHub {
    owner = "exiv2";
    repo = "exiv2";
    rev = "v${version}";
    hash = "sha256-Jim8vYWyCa16LAJ1GuP8cCzhXIc2ouo6hVsHg3UQbdg=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/Exiv2/exiv2/commit/c351c7cce317571934abf693055779a59df30d6e.patch";
      hash = "sha256-fWJT4IUBrAELl6ku0M1iTzGFX74le8Z0UzTJLU/gYls=";
    })
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    gettext
    graphviz
    libxslt
    removeReferencesTo
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
  ];

  propagatedBuildInputs = [
    brotli
    expat
    inih
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
  '' + lib.optionalString stdenv.hostPlatform.isAarch32 ''
    # Fix tests on arm
    # https://github.com/Exiv2/exiv2/issues/933
    rm -f ../tests/bugfixes/github/test_CVE_2018_12265.py
  '' + lib.optionalString stdenv.isDarwin ''
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$PWD/lib
    export LC_ALL=C

    # disable tests that requires loopback networking
    substituteInPlace  ../tests/bash_tests/testcases.py \
      --replace "def io_test(self):" "def io_disabled(self):"
  '';

  preFixup = ''
    remove-references-to -t ${stdenv.cc.cc} $lib/lib/*.so.*.*.* $out/bin/exiv2 $static/lib/*.a
  '';

  disallowedReferences = [ stdenv.cc.cc ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  meta = with lib; {
    homepage = "https://exiv2.org";
    description = "A library and command-line utility to manage image metadata";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wegank ];
  };
}
