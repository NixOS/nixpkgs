{ stdenv
, fetchzip
, pkg-config
, autoPatchelfHook
, installShellFiles
, ocl-icd
, zlib
}:

stdenv.mkDerivation rec {
  pname = "computecpp";
  version = "2.3.0";

  src = fetchzip {
    url = "https://computecpp.codeplay.com/downloads/computecpp-ce/${version}/x86_64-linux-gnu.tar.gz";
    hash = "sha256-AUHSls4BOX20PVKzDAp3RqpeRDwgbgYzz6CRvRN+kdk=";
    stripRoot = true;
  };

  dontStrip = true;

  buildInputs = [ stdenv.cc.cc.lib ocl-icd zlib ];
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
  };

  meta = with stdenv.lib; {
    description =
      "Accelerate Complex C++ Applications on Heterogeneous Compute Systems using Open Standards";
    homepage = "https://www.codeplay.com/products/computesuite/computecpp";
    license = licenses.unfree;
    maintainers = with maintainers; [ davidtwco ];
    platforms = [ "x86_64-linux" ];
  };
}
