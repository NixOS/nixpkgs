{ stdenv, fetchurl, jdk }:
with stdenv.lib;

stdenv.mkDerivation rec {
  name = "picoLisp-${version}";
  version = "3.1.11";
  src = fetchurl {
    url = "http://www.software-lab.de/${name}.tgz";
    sha256 = "01kgyz0lkz36lxvibv07qd06gwdxvvbain9f9cnya7a12kq3009i";
  };
  buildInputs = optional stdenv.is64bit jdk;
  patchPhase = optionalString stdenv.isArm ''
    sed -i s/-m32//g Makefile
    cat >>Makefile <<EOF
    ext.o: ext.c
    	\$(CC) \$(CFLAGS) -fPIC -D_OS='"\$(OS)"' \$*.c
    ht.o: ht.c
    	\$(CC) \$(CFLAGS) -fPIC -D_OS='"\$(OS)"' \$*.c
    EOF
  '';
  sourceRoot = ''picoLisp/src${optionalString stdenv.is64bit "64"}'';
  installPhase = ''
    cd ..

    mkdir -p "$out/share/picolisp" "$out/lib" "$out/bin"
    cp -r . "$out/share/picolisp/build-dir"
    ln -s "$out/share/picolisp/build-dir" "$out/lib/picolisp"
    ln -s "$out/lib/picolisp/bin/picolisp" "$out/bin/picolisp"

    cat >"$out/bin/pil" <<EOF
    #! /bin/sh
    exec $out/bin/picolisp $out/lib/picolisp/lib.l @lib/misc.l @lib/btree.l @lib/db.l @lib/pilog.l
    EOF
    chmod +x "$out/bin/pil"

    mkdir -p "$out/share/emacs"
    ln -s "$out/lib/picolisp/lib/el" "$out/share/emacs/site-lisp"
  '';

  meta = {
    description = "A simple Lisp with an integrated database.";
    homepage = http://picolisp.com/;
    license = licenses.mit;
    platform = platforms.all;
    maintainers = with maintainers; [ raskin ];
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://www.software-lab.de/down.html";
    };
  };
}
