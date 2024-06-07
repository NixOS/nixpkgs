{ autoPatchelfHook
, dpkg
, fetchurl
, lib
, libcxx
, stdenv
}:
stdenv.mkDerivation rec {
  pname = "edgetpu-compiler";
  version = "15.0";

  src = fetchurl rec {
    url = "https://packages.cloud.google.com/apt/pool/${pname}_${version}_amd64_${sha256}.deb";
    sha256 = "ce03822053c2bddbb8640eaa988396ae66f9bc6b9d6d671914acd1727c2b445a";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    libcxx
  ];

  unpackPhase = ''
    mkdir bin pkg

    dpkg -x $src pkg

    rm -r pkg/usr/share/lintian

    cp pkg/usr/bin/edgetpu_compiler_bin/edgetpu_compiler ./bin
    cp -r pkg/usr/share .

    rm -r pkg
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./{bin,share} $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "A command line tool that compiles a TensorFlow Lite model into an Edge TPU compatible file";
    mainProgram = "edgetpu_compiler";
    homepage = "https://coral.ai/docs/edgetpu/compiler";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ cpcloud ];
    platforms = [ "x86_64-linux" ];
  };
}
