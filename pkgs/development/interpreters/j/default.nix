{ stdenv, fetchFromGitHub, readline, libedit, bc }:

stdenv.mkDerivation rec {
  pname = "j";
  version = "807";
  jtype = "release";
  src = fetchFromGitHub {
    owner = "jsoftware";
    repo = "jsource";
    rev = "j${version}-${jtype}";
    sha256 = "1qciw2yg9x996zglvj2461qby038x89xcmfb3qyrh3myn8m1nq2n";
  };

  buildInputs = [ readline libedit bc ];
  bits = if stdenv.is64bit then "64" else "32";
  platform =
    if (stdenv.isAarch32 || stdenv.isAarch64) then "raspberry" else
    if stdenv.isLinux then "linux" else
    if stdenv.isDarwin then "darwin" else
    "unknown";

  doCheck = true;

  buildPhase = ''
    export SOURCE_DIR=$(pwd)
    export HOME=$TMPDIR
    export JLIB=$SOURCE_DIR/jlibrary

    export jbld=$HOME/bld
    export jplatform=${platform}
    export jmake=$SOURCE_DIR/make
    export jgit=$SOURCE_DIR
    export JBIN=$jbld/j${bits}/bin
    mkdir -p $JBIN

    echo $OUT_DIR

    cd make

    patchShebangs .
    sed -i jvars.sh -e "
      s@~/git/jsource@$SOURCE_DIR@;
      s@~/jbld@$HOME@;
      "

    sed -i $JLIB/bin/profile.ijs -e "s@'/usr/share/j/.*'@'$out/share/j'@;"

    # For future versions, watch
    # https://github.com/jsoftware/jsource/pull/4
    cp ./jvars.sh $HOME

    echo '
      #define jversion   "${version}"
      #define jplatform  "${platform}"
      #define jtype      "${jtype}"         // release,beta,...
      #define jlicense   "GPL3"
      #define jbuilder   "nixpkgs"  // website or email
      ' > ../jsrc/jversion.h

    ./build_jconsole.sh j${bits}
    ./build_libj.sh j${bits}
  '';

  checkPhase = ''
    echo 'i. 5' | $JBIN/jconsole | fgrep "0 1 2 3 4"

    # Now run the real tests
    cd $SOURCE_DIR/test
    for f in *.ijs
    do
      echo $f
      $JBIN/jconsole < $f > /dev/null || echo FAIL && echo PASS
    done
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r $JBIN "$out/bin"
    rm $out/bin/*.txt # Remove logs from the bin folder

    mkdir -p "$out/share/j"
    cp -r $JLIB/{addons,system} "$out/share/j"
    cp -r $JLIB/bin "$out"
  '';

  meta = with stdenv.lib; {
    description = "J programming language, an ASCII-based APL successor";
    maintainers = with maintainers; [ raskin synthetica ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.gpl3Plus;
    homepage = http://jsoftware.com/;
  };
}
