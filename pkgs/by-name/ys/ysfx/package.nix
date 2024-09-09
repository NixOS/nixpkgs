{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, freetype, juce, libX11, libXcursor, libXext, libXinerama, libXrandr, libglvnd
}:

stdenv.mkDerivation rec {
  pname = "ysfx";
  version = "0-unstable-2022-07-31";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "ysfx";
    rev = "8077347ccf4115567aed81400281dca57acbb0cc";
    hash = "sha256-pObuOb/PA9WkKB2FdMDCOd9TKmML+Sj2MybLP0YwT+8=";
  };

  # Provide latest dr_libs.
  dr_libs = fetchFromGitHub {
    owner = "mackron";
    repo = "dr_libs";
    rev = "e4a7765e598e9e54dc0f520b7e4416359bee80cc";
    hash = "sha256-rWabyCP47vd+EfibBWy6iQY/nFN/OXPNhkuOTSboJaU=";
  };

  prePatch = ''
    rmdir thirdparty/dr_libs
    ln -s ${dr_libs} thirdparty/dr_libs
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    freetype
    juce
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
    libglvnd
  ];

  cmakeFlags = [
    "-DYSFX_PLUGIN_COPY=OFF"
    "-DYSFX_PLUGIN_USE_SYSTEM_JUCE=ON"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r ysfx_plugin_artefacts/Release/VST3 $out/lib/vst3

    runHook postInstall
  '';

  meta = with lib; {
    description = "Hosting library for JSFX";
    homepage = "https://github.com/jpcima/ysfx";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
