{
  lib,
  stdenv,
  fetchurl,
  libX11,
  xorgproto,
  libXpm,
  libXt,
}:

stdenv.mkDerivation rec {
  pname = "xsokoban";
  version = "3.3c";

  src = fetchurl {
    url = "https://www.cs.cornell.edu/andru/release/${pname}-${version}.tar.gz";
    sha256 = "006lp8y22b9pi81x1a9ldfgkl1fbmkdzfw0lqw5y9svmisbafbr9";
  };

  buildInputs = [
    libX11
    xorgproto
    libXpm
    libXt
  ];

  env.NIX_CFLAGS_COMPILE = "-I${libXpm.dev}/include/X11 -Wno-error=implicit-int -Wno-error=implicit-function-declaration";

  hardeningDisable = [ "format" ];

  prePatch = ''
    substituteInPlace Makefile.in --replace 4755 0755
    substituteInPlace externs.h --replace 'malloc.h' 'stdlib.h'
  '';

  preConfigure = ''
    sed -e 's/getline/my_getline/' -i score.c
    sed -e 's/getpass/my_getpass/' -i externs.h display.c

    chmod a+rw config.h
    cat >>config.h <<EOF
    #define HERE "@nixos-packaged"
    #define WWW 0
    #define OWNER "$(whoami)"
    #define ROOTDIR "$out/lib/xsokoban"
    #define ANYLEVEL 1
    #define SCOREFILE ".xsokoban-score"
    #define LOCKFILE ".xsokoban-score-lock"
    EOF

    sed -i main.c \
      -e 's/getpass[(][^)]*[)]/PASSWORD/' \
      -e '/if [(]owner[)]/iowner=1;'
  '';

  preBuild = ''
    sed -i Makefile \
      -e "s@/usr/local/@$out/@" \
      -e "s@ /bin/@ @"
    mkdir -p $out/bin $out/share $out/man/man1 $out/lib
  '';

  meta = with lib; {
    description = "X sokoban";
    homepage = "https://www.cs.cornell.edu/andru/xsokoban.html";
    mainProgram = "xsokoban";
    license = licenses.publicDomain;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
  };
}
