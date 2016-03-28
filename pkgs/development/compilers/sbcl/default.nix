{ stdenv, fetchurl, writeText, sbclBootstrap
, sbclBootstrapHost ? "${sbclBootstrap}/bin/sbcl --disable-debugger --no-userinit --no-sysinit"
  # Meant for sbcl used for creating binaries portable to non-NixOS via save-lisp-and-die.
  # Note that the created binaries still need `patchelf --set-interpreter ...`
  # to get rid of ${glibc} dependency.
, purgeNixReferences ? false
}:

stdenv.mkDerivation rec {
  name    = "sbcl-${version}";
  version = "1.3.3";

  src = fetchurl {
    url    = "mirror://sourceforge/project/sbcl/sbcl/${version}/${name}-source.tar.bz2";
    sha256 = "0kzvwzz196ws9z20l8fm15m5gckhmkkc6lxvdib12mfvy80gcf6v";
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
  ''
  + (if purgeNixReferences
    then
      # This is the default location to look for the core; by default in $out/lib/sbcl
      ''
        sed 's@^\(#define SBCL_HOME\) .*$@\1 "/no-such-path"@' \
          -i src/runtime/runtime.c
      ''
    else
      # Fix software version retrieval
      ''
        sed -e "s@/bin/uname@$(command -v uname)@g" -i src/code/*-os.lisp
      ''
    );


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

  # Specifying $SBCL_HOME is only truly needed with `purgeNixReferences = true`.
  setupHook = writeText "setupHook.sh" ''
    envHooks+=(_setSbclHome)
    _setSbclHome() {
      export SBCL_HOME='@out@/lib/sbcl/'
    }
  '';

  meta = sbclBootstrap.meta // {
    inherit version;
    updateWalker = true;
  };
}
