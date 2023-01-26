{ lib, stdenv, fetchFromGitHub, makeBinaryWrapper
, alsaLib, libX11, libXext, libGL, libGLU
}:

stdenv.mkDerivation rec {
  pname = "minimacy";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "ambermind";
    repo = pname;
    rev =  version;
    sha256 = "i0Z1UKApX+elHmFgujwjiF7k6OmtFF37HJim464OMfU=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildInputs = [ libGL libGLU ] ++ lib.optionals stdenv.isLinux [ alsaLib libX11 libXext ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-Wno-unused-result";

  preBuild = ''
    pushd ${if stdenv.isDarwin then "macos/cmdline" else "unix"}
  '';

  # TODO: build graphic version for darwin
  buildFlags = (if stdenv.isDarwin then [ "nox" ] else [ "all" ]) ++ [ "CC=${stdenv.cc.targetPrefix}cc" ];

  postBuild = ''
    popd
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    bin/${if stdenv.isDarwin then "minimacyMac" else "minimacy"} system/demo/demo.fun.mandelbrot.mcy

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/minimacy
    cp -r {README.md,LICENSE,system,rom,topLevel.mcy} $out/lib/minimacy
    install bin/minimacy* -Dt $out/bin

    runHook postInstall
  '';

  postFixup = ''
    for prog in $out/bin/minimacy*;
      do wrapProgram $prog \
        --set MINIMACY $out/lib/minimacy
      done
  '';

  meta = {
    description = "An open-source minimalist computing technology";
    longDescription = ''
      Minimacy is an open-source minimalist computation system based on the principle "Less is more".
      It is designed and programmed by Sylvain Huet.
    '';
    maintainers = with lib.maintainers; [ jboy ];
    homepage    = "https://minimacy.net";
    license     = lib.licenses.gpl2;
    platforms   = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
