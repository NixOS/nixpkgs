{ stdenv
, fetchzip
, pkg-config
, autoPatchelfHook
, installShellFiles
, ncurses5
, ocl-icd
, zlib
}:

stdenv.mkDerivation rec {
  pname = "computecpp";
  version = "1.3.0";

  src = fetchzip {
    url = "https://computecpp.codeplay.com/downloads/computecpp-ce/${version}/ubuntu-16.04-64bit.tar.gz";
    sha256 = "1q6gqjpzz4a260gsd6mm1iv4z8ar3vxaypmgdwl8pb4i7kg6ykaz";
    stripRoot = true;
  };

  dontStrip = true;

  buildInputs = [ stdenv.cc.cc.lib ncurses5 ocl-icd zlib ];
  nativeBuildInputs = [ autoPatchelfHook pkg-config installShellFiles ];

  installPhase = ''
    runHook preInstall

    find ./lib -type f -exec install -D -m 0755 {} -t $out/lib \;
    find ./bin -type l -exec install -D -m 0755 {} -t $out/bin \;
    find ./bin -type f -exec install -D -m 0755 {} -t $out/bin \;
    find ./doc -type f -exec install -D -m 0644 {} -t $out/doc \;
    find ./include -type f -exec install -D -m 0644 {} -t $out/include \;

    runHook postInstall
  '';

  passthru = {
    isClang = true;
  } // stdenv.lib.optionalAttrs (stdenv.targetPlatform.isLinux || (stdenv.cc.isGNU && stdenv.cc.cc ? gcc)) {
    gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
  };

  meta = with stdenv.lib; {
    description =
      "Accelerate Complex C++ Applications on Heterogeneous Compute Systems using Open Standards";
    homepage = https://www.codeplay.com/products/computesuite/computecpp;
    license = licenses.unfree;
    maintainers = with maintainers; [ davidtwco ];
    platforms = [ "x86_64-linux" ];
  };
}
