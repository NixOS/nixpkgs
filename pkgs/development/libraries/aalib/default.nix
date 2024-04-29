{lib, stdenv, fetchurl, ncurses, automake}:

stdenv.mkDerivation rec {
  pname = "aalib";
  version = "1.4rc5";

  src = fetchurl {
    url = "mirror://sourceforge/aa-project/aalib-${version}.tar.gz";
    sha256 = "1vkh19gb76agvh4h87ysbrgy82hrw88lnsvhynjf4vng629dmpgv";
  };

  outputs = [ "bin" "dev" "out" "man" "info" ];
  setOutputFlags = false; # Doesn't support all the flags

  patches = [
    ./clang.patch

    # https://sourceforge.net/p/aa-project/patches/10/
    # Fix ther build against ncurses-6.5:
    #   aacurses.c:74:20: error: invalid use of incomplete typedef 'WINDOW' {aka 'struct _win_st'}
    (fetchurl {
      name = "ncurses-6.5.patch";
      url = "https://sourceforge.net/p/aa-project/patches/10/attachment/ncurses-6.5.patch";
      hash = "sha256-OWZMQ4cyUbwZjHFj+ovsZJtCpGm/gRkymsad6+QP+uk=";
    })
  ] # Fix implicit `int` on `main` error with newer versions of clang
    ++ lib.optionals stdenv.isDarwin [ ./darwin.patch ];

  # The fuloong2f is not supported by aalib still
  preConfigure = ''
    cp ${automake}/share/automake*/config.{sub,guess} .
    configureFlagsArray+=(
      "--bindir=$bin/bin"
      "--includedir=$dev/include"
      "--libdir=$out/lib"
    )
  '';

  buildInputs = [ ncurses ];

  configureFlags = [ "--without-x" "--with-ncurses=${ncurses.dev}" ];

  postInstall = ''
    mkdir -p $dev/bin
    mv $bin/bin/aalib-config $dev/bin/aalib-config
    substituteInPlace $out/lib/libaa.la --replace "${ncurses.dev}/lib" "${ncurses.out}/lib"
  '';

  meta = {
    description = "ASCII art graphics library";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl2;
  };
}
