{ lib
, stdenv
, fetchFromGitHub
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "qrcodegen";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "nayuki";
    repo = "QR-Code-generator";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-aci5SFBRNRrSub4XVJ2luHNZ2pAUegjgQ6pD9kpkaTY=";
  };

  sourceRoot = "${finalAttrs.src.name}/c";

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [
    stdenv.cc.cc.libllvm.out
  ];

  makeFlags = lib.optionals stdenv.cc.isClang [ "AR=llvm-ar" ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    ./qrcodegen-test

    runHook postCheck
=======
    rev = "v${version}";
    sha256 = "sha256-aci5SFBRNRrSub4XVJ2luHNZ2pAUegjgQ6pD9kpkaTY=";
  };

  preBuild = ''
    cd c/
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  installPhase = ''
    runHook preInstall

<<<<<<< HEAD
    install -Dt $out/lib/ libqrcodegen.a
    install -Dt $out/include/qrcodegen/ qrcodegen.h
=======
    mkdir -p $out/lib $out/include/qrcodegen
    cp libqrcodegen.a $out/lib
    cp qrcodegen.h $out/include/qrcodegen/
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://www.nayuki.io/page/qr-code-generator-library";
    description = "High-quality QR Code generator library in many languages";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
=======
  meta = with lib; {
    homepage = "https://www.nayuki.io/page/qr-code-generator-library";
    description = "High-quality QR Code generator library in many languages";
    license = licenses.mit;
    maintainers = with maintainers; [ mcbeth AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
# TODO: build the other languages
# TODO: multiple outputs
