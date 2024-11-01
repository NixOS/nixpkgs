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
    runHook preInstall
    install -Dm755 wasm3 -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/wasm3/wasm3";
    description = "Fastest WebAssembly interpreter, and the most universal runtime";
    platforms = platforms.all;
    maintainers = with maintainers; [ malbarbo ];
    license = licenses.mit;
    knownVulnerabilities = [
      # wasm3 expects all wasm code to be pre-validated, any users
      # should be aware that running unvalidated wasm will potentially
      # lead to RCE until upstream have added a builtin validator
      "CVE-2022-39974"
      "CVE-2022-34529"
      "CVE-2022-28990"
      "CVE-2022-28966"
      "CVE-2021-45947"
      "CVE-2021-45946"
      "CVE-2021-45929"
      "CVE-2021-38592"
    ];
  };
}
