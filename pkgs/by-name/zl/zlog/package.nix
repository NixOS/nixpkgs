{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  version = "1.2.18";
  pname = "zlog";

  src = fetchFromGitHub {
    owner = "HardySimpson";
    repo = pname;
    rev = version;
    hash = "sha256-79yyOGKgqUR1KI2+ngZd7jfVcz4Dw1IxaYfBJyjsxYc=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeFlagsArray+=(CFLAGS="-Wno-pointer-to-int-cast -Wno-newline-eof")
  '';

  meta = with lib; {
    description = "Reliable, high-performance, thread safe, flexible, clear-model, pure C logging library";
    homepage = "https://hardysimpson.github.io/zlog/";
    license = licenses.asl20;
    maintainers = [ maintainers.matthiasbeyer ];
    mainProgram = "zlog-chk-conf";
    platforms = platforms.unix;
  };
}
