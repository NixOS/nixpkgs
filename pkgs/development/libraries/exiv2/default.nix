{ stdenv
, fetchFromGitHub
, fetchpatch
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
}:

stdenv.mkDerivation rec {
  pname = "exiv2";
  version = "0.27.3";

  outputs = [ "out" "dev" "doc" "man" ];

  src = fetchFromGitHub {
    owner = "exiv2";
    repo  = "exiv2";
    rev = "v${version}";
    sha256 = "0d294yhcdw8ziybyd4rp5hzwknzik2sm0cz60ff7fljacv75bjpy";
  };

  patches = [
    # Fix aarch64 build https://github.com/Exiv2/exiv2/pull/1271
    (fetchpatch {
      name = "cmake-fix-aarch64.patch";
      url = "https://github.com/Exiv2/exiv2/commit/bbe0b70840cf28b7dd8c0b7e9bb1b741aeda2efd.patch";
      sha256 = "13zw1mn0ag0jrz73hqjhdsh1img7jvj5yddip2k2sb5phy04rzfx";
    })

    # Use correct paths with multiple outputs
    # https://github.com/Exiv2/exiv2/pull/1275
    (fetchpatch {
      url = "https://github.com/Exiv2/exiv2/commit/48f2c9dbbacc0ef84c8ebf4cb1a603327f0b8750.patch";
      sha256 = "vjB3+Ld4c/2LT7nq6uatYwfHTh+HeU5QFPFXuNLpIPA=";
    })
    # https://github.com/Exiv2/exiv2/pull/1294
    (fetchpatch {
      url = "https://github.com/Exiv2/exiv2/commit/306c8a6fd4ddd70e76043ab255734720829a57e8.patch";
      sha256 = "0D/omxYxBPGUu3uSErlf48dc6Ukwc2cEN9/J3e7a9eU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    gettext
    graphviz
    libxslt
  ];

  propagatedBuildInputs = [
    expat
    zlib
  ];

  checkInputs = [
    libxml2.bin
    python3
    which
  ];

  cmakeFlags = [
    "-DEXIV2_ENABLE_NLS=ON"
    "-DEXIV2_BUILD_DOC=ON"
  ];

  buildFlags = [
    "all"
    "doc"
  ];

  doCheck = true;

  # Test setup found by inspecting ${src}/.travis/run.sh; problems without cmake.
  checkTarget = "tests";

  preCheck = ''
    patchShebangs ../test/
    mkdir ../test/tmp

    ${stdenv.lib.optionalString (stdenv.isAarch64 || stdenv.isAarch32) ''
      # Fix tests on arm
      # https://github.com/Exiv2/exiv2/issues/933
      rm -f ../tests/bugfixes/github/test_CVE_2018_12265.py
    ''}

    ${stdenv.lib.optionalString stdenv.isDarwin ''
      export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$PWD/lib
      # Removing tests depending on charset conversion
      substituteInPlace ../test/Makefile --replace "conversions.sh" ""
      rm -f ../tests/bugfixes/redmine/test_issue_460.py
      rm -f ../tests/bugfixes/redmine/test_issue_662.py
      rm -f ../tests/bugfixes/github/test_issue_1046.py
     ''}
  '';

  # With CMake we have to enable samples or there won't be
  # a tests target. This removes them.
  postInstall = ''
    ( cd "$out/bin"
      mv exiv2 .exiv2
      rm *
      mv .exiv2 exiv2
    )
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.exiv2.org/";
    description = "A library and command-line utility to manage image metadata";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
