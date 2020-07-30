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
  version = "0.27.2";

  src = fetchFromGitHub {
    owner = "exiv2";
    repo  = "exiv2";
    rev = "v${version}";
    sha256 = "0n8il52yzbmvbkryrl8waz7hd9a2fdkw8zsrmhyh63jlvmmc31gf";
  };

  patches = [
    # included in next release
    (fetchpatch {
      name = "cve-2019-20421.patch";
      url = "https://github.com/Exiv2/exiv2/commit/a82098f4f90cd86297131b5663c3dec6a34470e8.patch";
      sha256 = "16r19qb9l5j43ixm5jqid9sdv5brlkk1wq0w79rm5agxq4kblfyc";
      excludes = [ "tests/bugfixes/github/test_issue_1011.py" "test/data/Jp2Image_readMetadata_loop.poc" ];
    })
  ];

  cmakeFlags = [
    "-DEXIV2_BUILD_PO=ON"
    "-DEXIV2_BUILD_DOC=ON"
    # the cmake package does not handle absolute CMAKE_INSTALL_INCLUDEDIR correctly
    # (setting it to an absolute path causes include files to go to $out/$out/include,
    #  because the absolute path is interpreted with root at $out).
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
    export LD_LIBRARY_PATH="$(realpath ../build/lib)"

    ${stdenv.lib.optionalString (stdenv.isAarch64 || stdenv.isAarch32) ''
      # Fix tests on arm
      # https://github.com/Exiv2/exiv2/issues/933
      rm -f ../tests/bugfixes/github/test_CVE_2018_12265.py
    ''}

    ${stdenv.lib.optionalString stdenv.isDarwin ''
      export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}`pwd`/lib
      # Removing tests depending on charset conversion
      substituteInPlace ../test/Makefile --replace "conversions.sh" ""
      rm -f ../tests/bugfixes/redmine/test_issue_460.py
      rm -f ../tests/bugfixes/redmine/test_issue_662.py
     ''}
  '';

  postCheck = ''
    (cd ../tests/ && python3 runner.py)
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

  # Fix CMake export paths.
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
