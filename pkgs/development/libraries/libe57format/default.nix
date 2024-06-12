{
  lib, stdenv,
  cmake,
  fetchpatch,
  fetchFromGitHub,
  boost,
  xercesc,
  icu,
}:

stdenv.mkDerivation rec {
  pname = "libe57format";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "asmaloney";
    repo = "libE57Format";
    rev = "v${version}";
    sha256 = "15l23spjvak5h3n7aj3ggy0c3cwcg8mvnc9jlbd9yc2ra43bx7bp";
  };

  patches = [
    # gcc11 header fix
    (fetchpatch {
      url = "https://github.com/asmaloney/libE57Format/commit/13f6a16394ce3eb50ea4cd21f31f77f53294e8d0.patch";
      sha256 = "sha256-4vVhKrCxnWO106DSAk+xxo4uk6zC89m9VQAPaDJ8Ed4=";
    })
  ];
  CXXFLAGS = [
    # GCC 13: error: 'int16_t' has not been declared in 'std'
    "-include cstdint"
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    icu
  ];

  propagatedBuildInputs = [
    # Necessary for projects that try to find libE57Format via CMake
    # due to the way that libe57format's CMake config is written.
    xercesc
  ];

  # The build system by default builds ONLY static libraries, and with
  # `-DE57_BUILD_SHARED=ON` builds ONLY shared libraries, see:
  #     https://github.com/asmaloney/libE57Format/issues/48
  #     https://github.com/asmaloney/libE57Format/blob/f657d470da5f0d185fe371c4c011683f6e30f0cb/CMakeLists.txt#L82-L89
  # We support building both by building statically and then
  # building an .so file here manually.
  # The way this is written makes this Linux-only for now.
  postInstall = ''
    cd $out/lib
    g++ -Wl,--no-undefined -shared -o libE57FormatShared.so -L. -Wl,-whole-archive -lE57Format -Wl,-no-whole-archive -lxerces-c
    mv libE57FormatShared.so libE57Format.so

    if [ "$dontDisableStatic" -ne "1" ]; then
      rm libE57Format.a
    fi
  '';

  meta = with lib; {
    description = "Library for reading & writing the E57 file format";
    homepage = "https://github.com/asmaloney/libE57Format";
    license = licenses.boost;
    maintainers = with maintainers; [ chpatrick nh2 ];
    platforms = platforms.linux; # because of the .so buiding in `postInstall` above
  };
}
