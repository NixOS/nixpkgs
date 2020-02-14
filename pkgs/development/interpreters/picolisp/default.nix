{ stdenv, fetchurl, jdk, w3m, openssl, makeWrapper }:
with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "picoLisp";
  version = "19.12";
  src = fetchurl {
    url = "https://www.software-lab.de/${pname}-${version}.tgz";
    sha256 = "10np0mhihr47r3201617zccrvzpkhdl1jwvz7zimk8kxpriydq2j";
  };
  buildInputs = [makeWrapper openssl] ++ optional stdenv.is64bit jdk;
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
  postBuild = ''
    cd ../src; make gate
  '';
  installPhase = ''
    cd ..

    mkdir -p "$out/share/picolisp" "$out/lib" "$out/bin"
    cp -r . "$out/share/picolisp/build-dir"
    ln -s "$out/share/picolisp/build-dir" "$out/lib/picolisp"
    ln -s "$out/lib/picolisp/bin/picolisp" "$out/bin/picolisp"
    ln -s "$out/lib/picolisp/bin/httpGate" "$out/bin/httpGate"


    makeWrapper $out/bin/picolisp $out/bin/pil \
      --prefix PATH : ${w3m}/bin \
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
