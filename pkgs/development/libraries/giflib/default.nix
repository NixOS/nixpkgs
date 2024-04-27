{ stdenv
, lib
, fetchurl
, fetchpatch
, fixDarwinDylibNames
, pkgsStatic
}:

stdenv.mkDerivation rec {
  pname = "giflib";
  version = "5.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/giflib/giflib-${version}.tar.gz";
    hash = "sha256-vn/70FfK3r4qoURUL9kMaDjGoIO16KkEi47jtmsp1fs=";
  };

  patches = [
    ./CVE-2021-40633.patch
  ] ++ lib.optionals stdenv.hostPlatform.isMinGW [
    # Build dll libraries.
    (fetchurl {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/001-mingw-build.patch?h=mingw-w64-giflib&id=4cf1e519bcf51338dc607d23388fca47d71790c0";
      sha256 = "KyJi3eqH/Ae+guEK6znraZI5+IPImaoYoW5NTkCvjsg=";
    })

    # Install executables.
    ./mingw-install-exes.patch
  ];

  nativeBuildInputs = lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  makeFlags = [
    "PREFIX=${builtins.placeholder "out"}"
  ];

  postPatch = ''
    # we don't want to build HTML documentation
    substituteInPlace doc/Makefile \
      --replace-fail "all: allhtml manpages" "all: manpages"
  '' + lib.optionalString stdenv.hostPlatform.isStatic ''
    # Upstream build system does not support NOT building shared libraries.
    sed -i '/all:/ s/$(LIBGIFSO)//' Makefile
    sed -i '/all:/ s/$(LIBUTILSO)//' Makefile
    sed -i '/-m 755 $(LIBGIFSO)/ d' Makefile
    sed -i '/ln -sf $(LIBGIFSOVER)/ d' Makefile
    sed -i '/ln -sf $(LIBGIFSOMAJOR)/ d' Makefile
  '';

  passthru.tests = {
    static = pkgsStatic.giflib;
  };

  meta = {
    description = "A library for reading and writing gif images";
    homepage = "https://giflib.sourceforge.net/";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    branch = "5.2";
  };
}
