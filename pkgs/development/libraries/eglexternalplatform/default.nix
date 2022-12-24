{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "eglexternalplatform";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "Nvidia";
    repo = "eglexternalplatform";
    rev = version;
    sha256 = "0lr5s2xa1zn220ghmbsiwgmx77l156wk54c7hybia0xpr9yr2nhb";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/include/"
    cp interface/eglexternalplatform.h "$out/include/"
    cp interface/eglexternalplatformversion.h "$out/include/"

    substituteInPlace eglexternalplatform.pc \
      --replace "/usr/include/EGL" "$out/include"
    mkdir -p "$out/share/pkgconfig"
    cp eglexternalplatform.pc "$out/share/pkgconfig/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "The EGL External Platform interface";
    homepage = "https://github.com/NVIDIA/eglexternalplatform";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hedning ];
  };
}
