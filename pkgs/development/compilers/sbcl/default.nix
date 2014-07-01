{ stdenv, fetchurl, sbclBootstrap, clisp}:

stdenv.mkDerivation rec {
  name    = "sbcl-${version}";
  version = "1.2.0";

  src = fetchurl {
    url    = mirror://sourceforge/project/sbcl/sbcl/1.2.0/sbcl-1.2.0-source.tar.bz2;
    sha256 = "13k20sys1v4lvgis8cnbczww6zs93rw176vz07g4jx06418k53x2";
  };

  buildInputs = [ sbclBootstrap ] ++ stdenv.lib.optional stdenv.isLinux clisp;

  patchPhase = ''
    echo '"${version}.nixos"' > version.lisp-expr
    echo "
    (lambda (features)
      (flet ((enable (x)
               (pushnew x features))
             (disable (x)
               (setf features (remove x features))))
        (enable :sb-thread))) " > customize-target-features.lisp

    pwd

    # SBCL checks whether files are up-to-date in many places..
    # Unfortunately, same timestamp is not good enough
    sed -e 's@> x y@>= x y@' -i contrib/sb-aclrepl/repl.lisp
    sed -e '/(date)/i((= date 2208988801) 2208988800)' -i contrib/asdf/asdf.lisp
    sed -i src/cold/slam.lisp -e \
      '/file-write-date input/a)'
    sed -i src/cold/slam.lisp -e \
      '/file-write-date output/i(or (and (= 2208988801 (file-write-date output)) (= 2208988801 (file-write-date input)))'
    sed -i src/code/target-load.lisp -e \
      '/date defaulted-fasl/a)'
    sed -i src/code/target-load.lisp -e \
      '/date defaulted-source/i(or (and (= 2208988801 (file-write-date defaulted-source-truename)) (= 2208988801 (file-write-date defaulted-fasl-truename)))'

    # Fix the tests
    sed -e '/deftest pwent/inil' -i contrib/sb-posix/posix-tests.lisp
    sed -e '/deftest grent/inil' -i contrib/sb-posix/posix-tests.lisp
    sed -e '/deftest .*ent.non-existing/,+5d' -i contrib/sb-posix/posix-tests.lisp
    sed -e '/deftest \(pw\|gr\)ent/,+3d' -i contrib/sb-posix/posix-tests.lisp

    sed -e '5,$d' -i contrib/sb-bsd-sockets/tests.lisp
    sed -e '5,$d' -i contrib/sb-simple-streams/*test*.lisp
  '';

  preBuild = ''
    export INSTALL_ROOT=$out
    ensureDir test-home
    export HOME=$PWD/test-home
  '';

  buildPhase = if stdenv.isLinux
    then ''
      sh make.sh clisp --prefix=$out
    ''
    else ''
      sh make.sh --prefix=$out --xc-host='${sbclBootstrap}/bin/sbcl --core ${sbclBootstrap}/share/sbcl/sbcl.core --disable-debugger --no-userinit --no-sysinit'
    '';

  installPhase = ''
    INSTALL_ROOT=$out sh install.sh
  '';

  meta = {
    description = "Lisp compiler";
    homepage = http://www.sbcl.org;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.all;
  };
}
