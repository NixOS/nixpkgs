{ lib, stdenv, fetchurl, jdk, w3m, openssl, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "picoLisp";
  version = "20.6";
  src = fetchurl {
    url = "https://www.software-lab.de/${pname}-${version}.tgz";
    sha256 = "0l51x98bn1hh6kv40sdgp0x09pzg5i8yxbcjvm9n5bxsd6bbk5w2";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [openssl] ++ lib.optional stdenv.is64bit jdk;
  patchPhase = ''
    sed -i "s/which java/command -v java/g" mkAsm

    ${lib.optionalString stdenv.isAarch32 ''
      sed -i s/-m32//g Makefile
      cat >>Makefile <<EOF
      ext.o: ext.c
        \$(CC) \$(CFLAGS) -fPIC -D_OS='"\$(OS)"' \$*.c
      ht.o: ht.c
        \$(CC) \$(CFLAGS) -fPIC -D_OS='"\$(OS)"' \$*.c
      EOF
    ''}
  '';
  sourceRoot = ''picoLisp/src${lib.optionalString stdenv.is64bit "64"}'';
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

  meta = with lib; {
    # darwin: build times out
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "A simple Lisp with an integrated database";
    homepage = "https://picolisp.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.all;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://www.software-lab.de/down.html";
    };
  };
}
