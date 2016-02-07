{ stdenv, fetchurl, sbclBootstrap, sbclBootstrapHost ? "${sbclBootstrap}/bin/sbcl --disable-debugger --no-userinit --no-sysinit" }:

stdenv.mkDerivation rec {
  name    = "sbcl-${version}";
  version = "1.3.2";

  src = fetchurl {
    url    = "mirror://sourceforge/project/sbcl/sbcl/${version}/${name}-source.tar.bz2";
    sha256 = "18mgj1h9wqi0zq4k7y5r5fk10mlbpgh3796d3dac75bpxabg30nk";
  };

  patchPhase = ''
    echo '"${version}.nixos"' > version.lisp-expr
    echo "
    (lambda (features)
      (flet ((enable (x)
               (pushnew x features))
             (disable (x)
               (setf features (remove x features))))
        #-arm
        (enable :sb-thread)
        #+arm
        (enable :arm))) " > customize-target-features.lisp

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

    # Fix software version retrieval
    sed -e "s@/bin/uname@$(command -v uname)@g" -i src/code/*-os.lisp

    # Fix the tests
    sed -e '/deftest pwent/inil' -i contrib/sb-posix/posix-tests.lisp
    sed -e '/deftest grent/inil' -i contrib/sb-posix/posix-tests.lisp
    sed -e '/deftest .*ent.non-existing/,+5d' -i contrib/sb-posix/posix-tests.lisp
    sed -e '/deftest \(pw\|gr\)ent/,+3d' -i contrib/sb-posix/posix-tests.lisp

    sed -e '5,$d' -i contrib/sb-bsd-sockets/tests.lisp
    sed -e '5,$d' -i contrib/sb-simple-streams/*test*.lisp

    # Use whatever `cc` the stdenv provides
    substituteInPlace src/runtime/Config.x86-64-darwin --replace gcc cc

    substituteInPlace src/runtime/Config.x86-64-darwin \
      --replace mmacosx-version-min=10.4 mmacosx-version-min=10.5
  '';

  preBuild = ''
    export INSTALL_ROOT=$out
    mkdir -p test-home
    export HOME=$PWD/test-home
  '';

  buildPhase = ''
    sh make.sh --prefix=$out --xc-host="${sbclBootstrapHost}"
  '';

  installPhase = ''
    INSTALL_ROOT=$out sh install.sh
  '';

  meta = sbclBootstrap.meta // {
    inherit version;
    updateWalker = true;
  };
}
