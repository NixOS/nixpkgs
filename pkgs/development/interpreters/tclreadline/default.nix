{
  lib,
  stdenv,
  fetchFromGitHub,
  automake,
  autoconf,
  libtool,
  readline,
  tcl,
  tk,
}:

tcl.mkTclDerivation rec {
  pname = "tclreadline";
  version = "2.3.8";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "tclreadline";
    rev = "v${version}";
    sha256 = "18jl56p0hwgynxpvr0v7b5mvvzc1m64fn61c0957bgb45mc250yq";
  };

  nativeBuildInputs = [
    automake
    autoconf
    libtool
  ];
  buildInputs = [
    readline
    tk
  ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--enable-tclshrl"
    "--enable-wishrl"
    "--with-tk=${tk}/lib"
    "--with-readline-includes=${readline.dev}/include/readline"
    "--with-libtool=${libtool}"
  ];

  # The provided makefile leaves a wrong reference to /build/ in RPATH,
  # so we fix it after checking that everything is also present in $out
  preFixup = lib.optionalString stdenv.isLinux ''
    needed_libraries=$(ls .libs | grep '\.\(so\|la\)$')
    for lib in $needed_libraries; do
      if ! ls $out/lib | grep "$lib"; then
        echo "$lib was not installed correctly"
        exit 1
      fi
    done
    for executable in $out/bin/{wishrl,tclshrl}; do
      patchelf --set-rpath \
        "$(patchelf --print-rpath "$executable" | sed "s@$builddir/.libs@$out/lib@")" \
        "$executable"
    done
  '';

  meta = with lib; {
    description = "GNU readline for interactive tcl shells";
    homepage = "https://github.com/flightaware/tclreadline";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
