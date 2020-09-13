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
  ];

  cmakeFlags = [
    "-DEXIV2_BUILD_PO=ON"
    "-DEXIV2_BUILD_DOC=ON"
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
    # Can probably be removed once https://github.com/Exiv2/exiv2/pull/1263 is merged.
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  outputs = [ "out" "dev" "doc" "man" ];

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

  buildFlags = [
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

  # Fix CMake export paths. Can be removed once https://github.com/Exiv2/exiv2/pull/1263 is merged.
  postFixup = ''
    sed -i "$dev/lib/cmake/exiv2/exiv2Config.cmake" \
        -e "/INTERFACE_INCLUDE_DIRECTORIES/ s@\''${_IMPORT_PREFIX}@$dev@" \
        -e "/Compute the installation prefix/ a set(_IMPORT_PREFIX \"$out\")" \
        -e "/^get_filename_component(_IMPORT_PREFIX/ d"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://www.exiv2.org/";
    description = "A library and command-line utility to manage image metadata";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
