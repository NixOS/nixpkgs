{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "j-${version}";
  version = "701_b";
  src = fetchurl {
    url = "http://www.jsoftware.com/download/j${version}_source.tar.gz";
    sha256 = "1gmjlpxcd647x690c4dxnf8h6ays8ndir6cib70h3zfnkrc34cys";
  };
  buildInputs = [ readline ];
  bits = if stdenv.is64bit then "64" else "32";

  doCheck = true;

  buildPhase = ''
    sed -i bin/jconfig -e '
        s@bits=32@bits=${bits}@g;
        s@readline=0@readline=1@;
        s@LIBREADLINE=""@LIBREADLINE=" -lreadline "@;
        s@-W1,soname,libj.so@-Wl,-soname,libj.so@
        '
    sed -i bin/build_libj -e 's@>& make.txt@ 2>\&1 | tee make.txt@'

    sed -i f2.c -e 's/_isnan(\*wv)/_isnan(y)/'

    touch *.c *.h
    sh -o errexit bin/build_jconsole
    [ -e j/bin/jconsole ]
    sh -o errexit bin/build_libj
    [ -e j/bin/libj.so ]
    sh -o errexit bin/build_defs
    [ -e defs/hostdefs.ijs ] && [ -e defs/netdefs.ijs ]
    sh -o errexit bin/build_tsdll
    [ -x libtsdll.so ]

    sed -i j/bin/profile.ijs -e "
        s@userx=[.] *'.j'@userx=. '/.j'@;
        s@bin,'/profilex.ijs'@user,'/profilex.ijs'@ ;
        /install=./ainstall=. install,'/share/j'
        "
  '';

  checkPhase = ''
    echo 'i. 5' | j/bin/jconsole | fgrep "0 1 2 3 4"
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r j/bin "$out/bin"
    rm "$out/bin/profilex_template.ijs"

    mkdir -p "$out/share/j"

    cp -r docs j/addons j/system "$out/share/j"
  '';

  meta = with stdenv.lib; {
    description = "J programming language, an ASCII-based APL successor";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    homepage = http://jsoftware.com/;
  };
}
