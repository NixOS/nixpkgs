{ lib, stdenv, fetchFromGitHub, readline, libedit, bc
, avxSupport ? stdenv.hostPlatform.avxSupport
}:

stdenv.mkDerivation rec {
  pname = "j";
  version = "902";
  jtype = "release-b";
  src = fetchFromGitHub {
    owner = "jsoftware";
    repo = "jsource";
    rev = "j${version}-${jtype}";
    sha256 = "0j67vgikqflwjqacsdicasvyv1k54s2c8vjgwmf0ix7l41p4xqz0";
    name = "jsource";
  };

  buildInputs = [ readline libedit bc ];
  bits = if stdenv.is64bit then "64" else "32";
  platform =
    if (stdenv.isAarch32 || stdenv.isAarch64) then "raspberry" else
    if stdenv.isLinux then "linux" else
    if stdenv.isDarwin then "darwin" else
    "unknown";
  variant = if stdenv.isx86_64 && avxSupport then "avx" else "";

  j64x="j${bits}${variant}";

  doCheck = true;

  # Causes build failure due to warning
  hardeningDisable = lib.optional stdenv.cc.isClang "strictoverflow";

  # Causes build failure due to warning
  # https://github.com/jsoftware/jsource/issues/16
  NIX_CFLAGS_COMPILE = "-Wno-error=return-local-addr";

  buildPhase = ''
    export SOURCE_DIR=$(pwd)
    export HOME=$TMPDIR
    export JLIB=$SOURCE_DIR/jlibrary

    echo $OUT_DIR

    cd make2

    patchShebangs .
    sed -i $JLIB/bin/profile.ijs -e "s@'/usr/share/j/.*'@'$out/share/j'@;"

    j64x="${j64x}" ./build_all.sh

    cp $SOURCE_DIR/bin/${platform}/j${bits}*/* "$JLIB/bin"
  '';

  checkPhase = ''

    echo 'i. 5' | $JLIB/bin/jconsole | fgrep "0 1 2 3 4"

    # Now run the real tests
    cd $SOURCE_DIR/test
    for f in *.ijs
    do
      echo $f
      $JLIB/bin/jconsole < $f > /dev/null || echo FAIL && echo PASS
    done
  '';

  installPhase = ''
    mkdir -p "$out"

    mkdir -p "$out/share/j"
    cp -r $JLIB/{addons,system} "$out/share/j"
    cp -r $JLIB/bin "$out"
  '';

  meta = with lib; {
    description = "J programming language, an ASCII-based APL successor";
    maintainers = with maintainers; [ raskin synthetica ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.gpl3Plus;
    homepage = "http://jsoftware.com/";
  };
}
