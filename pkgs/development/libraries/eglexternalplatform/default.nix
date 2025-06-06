{ stdenvNoCC
, lib
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "eglexternalplatform";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "Nvidia";
    repo = "eglexternalplatform";
    rev = "7c8f8e2218e46b1a4aa9538520919747f1184d86";
    sha256 = "0lr5s2xa1zn220ghmbsiwgmx77l156wk54c7hybia0xpr9yr2nhb";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include/
    cp interface/* $out/include/

    substituteInPlace eglexternalplatform.pc \
      --replace "/usr/include/EGL" "$out/include"
    install -Dm644 {.,$out/share/pkgconfig}/eglexternalplatform.pc

    runHook postInstall
  '';

  meta = with lib; {
    description = "EGL External Platform interface";
    homepage = "https://github.com/NVIDIA/eglexternalplatform";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hedning ];
  };
}
