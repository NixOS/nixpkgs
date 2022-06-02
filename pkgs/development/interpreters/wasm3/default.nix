{ lib, stdenv, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "wasm3";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "wasm3";
    repo = "wasm3";
    rev = "v${version}";
    sha256 = "07zzmk776j8ydyxhrnnjiscbhhmz182a62r6aix6kfk5kq2cwia2";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_WASI=simple"
  ];

  installPhase = ''
    runHook preInstal
    install -Dm755 wasm3 -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/wasm3/wasm3";
    description = "The fastest WebAssembly interpreter, and the most universal runtime.";
    platforms = platforms.all;
    maintainers = with maintainers; [ malbarbo ];
    license = licenses.mit;
  };
}
