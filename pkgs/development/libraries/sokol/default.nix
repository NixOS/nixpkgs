{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "sokol";
  version = "unstable-2022-06-13";

  src = fetchFromGitHub {
    owner = "floooh";
    repo = "sokol";
    rev = "3c7016105f3b7463f0cfc74df8a55642e5448c11";
    sha256 = "sha256-dKHb6GTp5aJPuWWXI4ZYnhgdXs23gGWyPymGPGwxcLY=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/sokol
    cp *.h $out/include/sokol/
    cp -R util $out/include/sokol/util

    runHook postInstall
  '';

  meta = with lib; {
    description = "Minimal cross-platform standalone C headers";
    homepage = "https://github.com/floooh/sokol";
    license = licenses.zlib;
    platforms = platforms.all;
    maintainers = with maintainers; [ jonnybolton ];
  };
}

