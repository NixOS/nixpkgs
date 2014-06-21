{ stdenv, fetchurl, gcc, openssl, picolisp32 }:

stdenv.mkDerivation rec {
  version = "3.1.6";
  name = "picolisp-${version}";

  src = fetchurl {
    url = "http://software-lab.de/picoLisp-${version}.tgz";
    sha256 = "0b6cfpwabd275l5gkkn051jfjy8mir833p28aaippzq262qvas45";
  };

  buildInputs = [ stdenv gcc openssl picolisp32 ];

  bootstrap = picolisp32;
  wrapper = ./wrap.sh;

  buildCommand = ''
    mkdir -p "$out"
    mkdir -p "$out"/bin
    mkdir -p "$out"/share/picolisp/img
    mkdir -p "$out"/share/picolisp/loc
    mkdir -p "$out"/share/picolisp/lib
    mkdir -p "$out"/lib/picolisp/bin
    mkdir -p "$out"/share/emacs/site-lisp/picolisp
    mkdir -p "$out"/share/picolisp
    tar -xvf "$src"
    cd picoLisp/src64
    sed -e "s@/usr/@$bootstrap/@g" -i mkAsm
    make
    cd ..
    cp bin/* "$out"/bin
    cp img/* "$out"/share/picolisp/img
    cp loc/* "$out"/share/picolisp/loc
    cp -r lib "$out"/share/picolisp/
    cp lib/el/*.el "$out"/share/emacs/site-lisp/picolisp
    cp -r *.l lib.css app games misc test "$out"/share/picolisp/
    sed -e "1s@.*@#!$out/bin/picolisp $out/share/picolisp/lib.l@g" "$out"/bin/pil >"$out"/bin/pil.wrapped
    sed -e "1s@.*@#!$out/bin/picolisp $out/share/picolisp/lib.l@g" "$out"/bin/psh >"$out"/bin/psh.wrapped
    sed -e "1s@.*@#!$out/bin/picolisp $out/share/picolisp/lib.l@g" "$out"/bin/watchdog >"$out"/bin/watchdog.wrapped
    sed -e "1s@.*@#!$out/bin/picolisp $out/share/picolisp/lib.l@g" "$out"/bin/replica >"$out"/bin/replica.wrapped
    sed -e "s@PICOLISP@$out/bin/picolisp@g" -e "s@LIB@$out/share/picolisp/lib.l@g" -e "s@WRAPPED@$out/bin/pil.wrapped@g" "$wrapper" >"$out"/bin/pil
    sed -e "s@PICOLISP@$out/bin/picolisp@g" -e "s@LIB@$out/share/picolisp/lib.l@g" -e "s@WRAPPED@$out/bin/psh.wrapped@g" "$wrapper" >"$out"/bin/psh
    sed -e "s@PICOLISP@$out/bin/picolisp@g" -e "s@LIB@$out/share/picolisp/lib.l@g" -e "s@WRAPPED@$out/bin/watchdog.wrapped@g" "$wrapper" >"$out"/bin/watchdog
    sed -e "s@PICOLISP@$out/bin/picolisp@g" -e "s@LIB@$out/share/picolisp/lib.l@g" -e "s@WRAPPED@$out/bin/replica.wrapped@g" "$wrapper" >"$out"/bin/replica
  '';
  meta = {
    description = "An interpreter for a small Lisp dialect with builtin DB";
    homepage = "http://www.software-lab.de/down.html";
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.mit;
  };
}

