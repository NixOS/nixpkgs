{ stdenv, fetchurl, jdk, makeWrapper }:
with stdenv.lib;

stdenv.mkDerivation rec {
  name = "picoLisp-${version}";
  version = "18.12";
  src = fetchurl {
    url = "https://www.software-lab.de/${name}.tgz";
    sha256 = "0hvgq2vc03bki528jqn95xmvv7mw8xx832spfczhxc16wwbrnrhk";
  };
  buildInputs = [makeWrapper] ++ optional stdenv.is64bit jdk;
  patchPhase = ''
    sed -i "s/which java/command -v java/g" mkAsm

    ${optionalString stdenv.isAarch32 ''
      sed -i s/-m32//g Makefile
      cat >>Makefile <<EOF
      ext.o: ext.c
        \$(CC) \$(CFLAGS) -fPIC -D_OS='"\$(OS)"' \$*.c
      ht.o: ht.c
        \$(CC) \$(CFLAGS) -fPIC -D_OS='"\$(OS)"' \$*.c
      EOF
    ''}
  '';
  sourceRoot = ''picoLisp/src${optionalString stdenv.is64bit "64"}'';
  installPhase = ''
    cd ..

    mkdir -p "$out/share/picolisp" "$out/lib" "$out/bin"
    cp -r . "$out/share/picolisp/build-dir"
    ln -s "$out/share/picolisp/build-dir" "$out/lib/picolisp"
    ln -s "$out/lib/picolisp/bin/picolisp" "$out/bin/picolisp"


    makeWrapper $out/bin/picolisp $out/bin/pil \
      --add-flags "$out/lib/picolisp/lib.l" \
      --add-flags "@lib/misc.l" \
      --add-flags "@lib/btree.l" \
      --add-flags "@lib/db.l" \
      --add-flags "@lib/pilog.l"

    mkdir -p "$out/share/emacs"
    ln -s "$out/lib/picolisp/lib/el" "$out/share/emacs/site-lisp"
  '';

  meta = {
    description = "A simple Lisp with an integrated database";
    homepage = https://picolisp.com/;
    license = licenses.mit;
    platforms = platforms.all;
    broken = stdenv.isDarwin; # times out
    maintainers = with maintainers; [ raskin tohl ];
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://www.software-lab.de/down.html";
    };
  };
}
