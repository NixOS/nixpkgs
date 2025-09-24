{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  openssl,
  curl,
  avahi,
  ndi,
}:

stdenv.mkDerivation {
  pname = "v4l2-to-ndi";
  version = "0-unstable-2022-09-14";

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    openssl
    curl
    avahi
    ndi
  ];

  src = fetchFromGitHub {
    owner = "lplassman";
    repo = "V4L2-to-NDI";
    rev = "4dd5e9594acc4f154658283ee52718fa58018ac9";
    hash = "sha256-blB8HRfO2k1zsZamugOXZzW8uS26uf8+7sA0zBbV/K4=";
  };

  buildPhase = ''
    runHook preBuild
    mkdir build
    g++ -std=c++14 -pthread  -Wl,--allow-shlib-undefined -Wl,--as-needed \
    -I'NDI SDK for Linux'/include/ \
    -Iinclude/ \
    -L'NDI SDK for Linux'/lib/x86_64-linux-gnu \
    -o build/v4l2ndi main.cpp PixelFormatConverter.cpp -lndi -ldl
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -r build $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Video input (V4L2) to NDI converter";
    homepage = "https://github.com/lplassman/V4L2-to-NDI";
    license = licenses.mit;
    maintainers = with maintainers; [
      pinpox
      MayNiklas
    ];
    mainProgram = "v4l2ndi";
    platforms = platforms.linux;
  };
}
