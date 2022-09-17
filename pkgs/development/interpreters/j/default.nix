{ lib
, stdenv
, fetchFromGitHub
, bc
, libedit
, readline
, avxSupport ? stdenv.hostPlatform.avxSupport
}:

stdenv.mkDerivation rec {
  pname = "j";
  version = "904-beta-c";

  src = fetchFromGitHub {
    name = "${pname}-source";
    owner = "jsoftware";
    repo = "jsource";
    rev = "j${version}";
    hash = "sha256-MzEO/saHEBl1JwVlFC6P2UKm9RZnV7KVrNd9h4cPV/w=";
  };

  buildInputs = [
    readline
    libedit
    bc
  ];

  dontConfigure = true;

  # emulating build_all.sh configuration variables
  jplatform =
    if stdenv.isDarwin then "darwin"
    else if stdenv.hostPlatform.isAarch then "raspberry"
    else if stdenv.isLinux then "linux"
    else "unsupported";

  j64x =
    if stdenv.is32bit then "j32"
    else if stdenv.isx86_64 then
      if (stdenv.isLinux && avxSupport) then "j64avx" else "j64"
    else if stdenv.isAarch64 then
      if stdenv.isDarwin then "j64arm" else "j64"
    else "unsupported";

  buildPhase = ''
    runHook preBuild

    export SRCDIR=$(pwd)
    export HOME=$TMPDIR
    export JLIB=$SRCDIR/jlibrary
    export CC=cc

    cd make2

    patchShebangs .

    j64x="${j64x}" jplatform="${jplatform}" ./build_all.sh

    cp -v $SRCDIR/bin/${jplatform}/${j64x}/* "$JLIB/bin"

    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    echo "Smoke test"
    echo 'i. 10' | $JLIB/bin/jconsole | fgrep "0 1 2 3 4 5 6 7 8 9"

    # Now run the real tests
    pushd $SRCDIR/test
    for f in *.ijs
    do
      echo -n "test $f: "
      $JLIB/bin/jconsole < $f > /dev/null || echo FAIL && echo PASS
    done
    popd

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/j/"
    cp -r $JLIB/{addons,system} "$out/share/j"
    cp -r $JLIB/bin "$out"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://jsoftware.com/";
    description = "J programming language, an ASCII-based APL successor";
    longDescription = ''
      J is a high-level, general-purpose programming language that is
      particularly suited to the mathematical, statistical, and logical analysis
      of data. It is a powerful tool for developing algorithms and exploring
      problems that are not already well understood.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin synthetica AndersonTorres ];
    platforms = with platforms; unix;
  };
}
