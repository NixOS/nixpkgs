{
  stdenv,
  cmake,
  fetchFromGitHub,
  boost,
  xercesc,
  icu,

  dos2unix,
  fetchpatch,
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
  ];

  propagatedBuildInputs = [
    # Necessary for projects that try to find libE57Format via CMake
    # due to the way that libe57format's CMake config is written.
    xercesc
  ];

  # TODO: Remove CMake patching when https://github.com/asmaloney/libE57Format/pull/60 is available.

  # GNU patch cannot patch `CMakeLists.txt` that has CRLF endings,
  # see https://unix.stackexchange.com/questions/239364/how-to-fix-hunk-1-failed-at-1-different-line-endings-message/243748#243748
  # so convert it first.
  prePatch = ''
    ${dos2unix}/bin/dos2unix CMakeLists.txt
  '';
  patches = [
    (fetchpatch {
      name = "libE57Format-cmake-Fix-config-filename.patch";
      url = "https://github.com/asmaloney/libE57Format/commit/279d8d6b60ee65fb276cdbeed74ac58770a286f9.patch";
      sha256 = "0fbf92hs1c7yl169i7zlbaj9yhrd1yg3pjf0wsqjlh8mr5m6rp14";
    })
  ];
  # It appears that while the patch has
  #     diff --git a/cmake/E57Format-config.cmake b/cmake/e57format-config.cmake
  #     similarity index 100%
  #     rename from cmake/E57Format-config.cmake
  #     rename to cmake/e57format-config.cmake
  # GNU patch doesn't interpret that.
  postPatch = ''
    mv cmake/E57Format-config.cmake cmake/e57format-config.cmake
  '';

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
