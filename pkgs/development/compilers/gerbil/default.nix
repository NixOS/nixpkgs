{ callPackage, fetchFromGitHub, gambit, bash }:

callPackage ./build.nix rec {
  version = "0.15.1";
  git-version = "0.15.1";
  src = fetchFromGitHub {
    owner = "vyzo";
    repo = "gerbil";
    rev = "v${version}";
    sha256 = "0qpqms66hz41wwhxb1z0fnzj96ivkm7qi9h9d7lhlr3fsxm1kp1n";
  };
  configurePhase = ''
    grep -Fl '"gsc"' `find . -type f -name '*.s*'` | while read f ; do
      substituteInPlace "$f" --replace '"gsc"' '"${gambit}/bin/gsc"' ;
    done ;
    for f in etc/gerbil.el src/std/make.ss ; do
      substituteInPlace "$f" --replace '"gxc"' "\"$out/bin/gxc\"" ;
    done ;

    # Enable all optional libraries
    substituteInPlace "src/std/build-features.ss" --replace '#f' '#t' ;

    # Enable autodetection of a default GERBIL_HOME
    for i in src/gerbil/boot/gx-init-exe.scm src/gerbil/boot/gx-init.scm ; do
      substituteInPlace "$i" --replace '(define default-gerbil-home #f)' "(define default-gerbil-home \"$out/gerbil\")" ;
      substituteInPlace "$i" --replace '(getenv "GERBIL_HOME" #f)' "(getenv \"GERBIL_HOME\" \"$out/gerbil\")" ;
    done ;
    for i in src/gerbil/boot/gxi-init.scm src/gerbil/compiler/driver.ss src/gerbil/runtime/gx-gambc.scm src/std/build.ss src/tools/build.ss ; do
      substituteInPlace "$i" --replace '(getenv "GERBIL_HOME")' "(getenv \"GERBIL_HOME\" \"$out/gerbil\")" ;
    done
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/gerbil $out/bin
    cp -fa bin lib etc doc $out/gerbil
    cat > $out/gerbil/bin/gxi <<EOF
#!${bash}/bin/bash -e
GERBIL_GSI=${gambit}/bin/gsi
export GERBIL_HOME=$out/gerbil
case "\$1" in -:*) GSIOPTIONS="\$1" ; shift ;; esac
if [[ \$# = 0 ]] ; then
  exec "\$GERBIL_GSI" \$GSIOPTIONS "\$GERBIL_HOME/lib/gxi-init" "\$GERBIL_HOME/lib/gxi-interactive" -
else
  exec "\$GERBIL_GSI" \$GSIOPTIONS "\$GERBIL_HOME/lib/gxi-init" "\$@"
fi
EOF
    (cd $out/bin ; ln -s ../gerbil/bin/* .)
    runHook postInstall
  '';
}
