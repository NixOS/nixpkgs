{
  stdenv,
  cmake,
  fetchFromGitHub,
  boost,
  xercesc,
  icu,
}:

stdenv.mkDerivation rec {
  pname = "libe57format";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "asmaloney";
    repo = "libE57Format";
    rev = "v${version}";
    sha256 = "05z955q68wjbd9gc5fw32nqg69xc82n2x75j5vchxzkgnn3adcpi";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    icu
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

  meta = with stdenv.lib; {
    description = "Library for reading & writing the E57 file format (fork of E57RefImpl)";
    homepage = "https://github.com/asmaloney/libE57Format";
    license = licenses.boost;
    maintainers = with maintainers; [ chpatrick nh2 ];
    platforms = platforms.linux; # because of the .so buiding in `postInstall` above
  };
}
