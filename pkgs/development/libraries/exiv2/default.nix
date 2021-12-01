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
}:

stdenv.mkDerivation rec {
  pname = "exiv2";
  version = "0.27.5";

  outputs = [ "out" "dev" "doc" "man" ];

  src = fetchFromGitHub {
    owner = "exiv2";
    repo  = "exiv2";
    rev = "v${version}";
    sha256 = "sha256-5kdzw/YzpYldfHjUSPOzu3gW2TPgxt8Oxs0LZDFphgA=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    gettext
    graphviz
    libxslt
  ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

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

    ${lib.optionalString (stdenv.isAarch64 || stdenv.isAarch32) ''
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

  meta = with lib; {
    homepage = "https://www.exiv2.org/";
    description = "A library and command-line utility to manage image metadata";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
