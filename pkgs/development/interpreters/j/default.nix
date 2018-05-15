{ stdenv, fetchFromGitHub, readline, libedit }:

stdenv.mkDerivation rec {
  name = "j-${version}";
  version = "808";
  jtype = "release";
  src = fetchFromGitHub {
    owner = "jsoftware";
    repo = "jsource";
    rev = "j${version}-${jtype}";
    sha256 = "1sshm04p3yznlhfp6vyc7g8qxw95y67vhnh92cmz3lfy69n2q6bf";
  };

  buildInputs = [ readline libedit ];
  bits = if stdenv.is64bit then "64" else "32";
  platform =
    /*if stdenv.isRaspberryPi then "raspberry" else*/
    if stdenv.isLinux then "linux" else
    if stdenv.isDarwin then "darwin" else
    "unknown";

  doCheck = true;

  buildPhase = ''
    export SOURCE_DIR=$(pwd)
    export HOME=$TMPDIR
    export JBIN=$HOME/j${bits}/bin
    export JLIB=$SOURCE_DIR/jlibrary
    mkdir -p $JBIN

    cd make

    patchShebangs .
    sed -i jvars.sh -e '
      s@~/gitdev/jsource@$SOURCE_DIR@;
      s@~/jbld@$HOME@;
      s@linux@${platform}@;
      '

    sed -i $JLIB/bin/profile.ijs -e "s@'/usr/share/j/.*'@'$out/share/j'@;"

    # For future versions, watch
    # https://github.com/jsoftware/jsource/pull/4
    cp ./jvars.sh $HOME

    echo '
      #define jversion   "${version}"
      #define jplatform  "${platform}"
      #define jtype      "${jtype}"         // release,beta,...
      #define jlicense   "GPL3"
      #define jbuilder   "unknown"  // website or email
      ' > ../jsrc/jversion.h

    ./build_jconsole.sh j${bits}
    ./build_libj.sh j${bits}
  '';

  checkPhase = ''
    echo 'i. 5' | $JBIN/jconsole | fgrep "0 1 2 3 4"

    # Now run the real tests
    cd $SOURCE_DIR/test
    # for f in *.ijs
    # do
    #   echo $f
    #   $JBIN/jconsole < $f
    # done
  '';

  installPhase = ''
    mkdir -p "$out"
    cp -r $JBIN "$out/bin"

    mkdir -p "$out/share/j"
    cp -r $JLIB/{addons,system} "$out/share/j"
    cp -r $JLIB/bin "$out"
  '';

  meta = with stdenv.lib; {
    description = "J programming language, an ASCII-based APL successor";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    homepage = http://jsoftware.com/;
  };
}
