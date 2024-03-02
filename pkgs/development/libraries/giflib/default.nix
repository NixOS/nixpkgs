{ stdenv
, lib
, fetchurl
, fetchpatch
, fixDarwinDylibNames
, pkgsStatic
}:

stdenv.mkDerivation rec {
  pname = "giflib";
  version = "5.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/giflib/giflib-${version}.tar.gz";
    sha256 = "1gbrg03z1b6rlrvjyc6d41bc8j1bsr7rm8206gb1apscyii5bnii";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-28506.patch";
      url = "https://src.fedoraproject.org/rpms/giflib/raw/2e9917bf13df114354163f0c0211eccc00943596/f/CVE-2022-28506.patch";
      sha256 = "sha256-TBemEXkuox8FdS9RvjnWcTWPaHRo4crcwSR9czrUwBY=";
    })
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # https://sourceforge.net/p/giflib/bugs/133/
    (fetchpatch {
      name = "darwin-soname.patch";
      url = "https://sourceforge.net/p/giflib/bugs/_discuss/thread/4e811ad29b/c323/attachment/Makefile.patch";
      sha256 = "12afkqnlkl3n1hywwgx8sqnhp3bz0c5qrwcv8j9hifw1lmfhv67r";
      extraPrefix = "./";
    })
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

  postPatch = lib.optionalString stdenv.hostPlatform.isStatic ''
    # Upstream build system does not support NOT building shared libraries.
    sed -i '/all:/ s/libgif.so//' Makefile
    sed -i '/all:/ s/libutil.so//' Makefile
    sed -i '/-m 755 libgif.so/ d' Makefile
    sed -i '/ln -sf libgif.so/ d' Makefile
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
