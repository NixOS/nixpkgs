{ stdenv
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
}:

stdenv.mkDerivation rec {
  pname = "exiv2";
  version = "0.27.1";

  src = fetchFromGitHub rec {
    owner = "exiv2";
    repo  = "exiv2";
    rev = version;
    sha256 = "0b5m921070fkyif0zlyb49gly3p6xd0hv1jyym4j25hx12gzbx0c";
  };

  patches = [
    # https://github.com/Exiv2/exiv2/commit/aae88060ca85a483cd7fe791ba116c04d96c0bf9#comments
    ./fix-cmake.patch
  ];

  cmakeFlags = [
    "-DEXIV2_BUILD_PO=ON"
    "-DEXIV2_BUILD_DOC=ON"
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

  doCheck = stdenv.isLinux;

  # Test setup found by inspecting ${src}/.travis/run.sh; problems without cmake.
  checkTarget = "tests";

  preCheck = ''
    patchShebangs ../test/
    mkdir ../test/tmp
    export LD_LIBRARY_PATH="$(realpath ../build/lib)"

    # Fix tests on Aarch64
    ${stdenv.lib.optionalString stdenv.isAarch64 ''
      rm -f ../tests/bugfixes/github/test_CVE_2018_12265.py
    ''}
  '';

  postCheck = ''
    (cd ../tests/ && python3 runner.py)
  '';

  # With cmake we have to enable samples or there won't be
  # a tests target. This removes them.
  postInstall = ''
    ( cd "$out/bin"
      mv exiv2 .exiv2
      rm *
      mv .exiv2 exiv2
    )
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.exiv2.org/;
    description = "A library and command-line utility to manage image metadata";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
