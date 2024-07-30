{ lib, stdenv, cosmopolitan, unzip, bintools-unwrapped }:

stdenv.mkDerivation rec {
  pname = "python-cosmopolitan";
  version = "3.6.14";

  src = cosmopolitan.dist;

  nativeBuildInputs = [ bintools-unwrapped unzip ];

  # slashes are significant because upstream uses o/$(MODE)/foo.o
  buildFlags = [ "o//third_party/python" ];
  checkTarget = "o//third_party/python/test";
  enableParallelBuilding = true;

  doCheck = true;
  dontConfigure = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install o/third_party/python/*.com -Dt $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://justine.lol/cosmopolitan/";
    description = "Actually Portable Python using Cosmopolitan";
    platforms = platforms.x86_64;
    badPlatforms = platforms.darwin;
    license = licenses.isc;
    maintainers = teams.cosmopolitan.members;
    mainProgram = "python.com";
  };
}
