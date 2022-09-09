{ stdenv, lib, fetchFromGitHub, luajit, imgui }:

stdenv.mkDerivation rec {
  pname = "cimgui";
  version = imgui.version;

  src = fetchFromGitHub {
    owner = "cimgui";
    repo = "cimgui";
    rev = version;
    sha256 = "90PSGInYIBj8JqSOybqvtUDTa4YjRlQzNkak8jIIEkM=";
    fetchSubmodules = false;
  };

  patchPhase = ''
    rm cimgui.cpp
    rm cimgui.h
    rm -rf generator/output
    cp -r ${imgui}/include/imgui/. imgui
  '';

  buildPhase = ''
    runHook preBuild

    pushd generator
    mkdir output
    ${luajit}/bin/luajit generator.lua gcc "internal" glfw opengl3 opengl2 sdl
    popd
    make cimgui.so

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    mkdir -p $out/lib

    cp cimgui.h $out/include
    cp cimgui.cpp $out/include
    cp cimgui.so $out/lib
    ln -s $out/lib/cimgui.so $out/lib/libcimgui.so

    runHook postInstall
  '';

  meta = with lib; {
    description = "Thin C-API wrapper for Dear ImGui";
    homepage = "https://github.com/cimgui/cimgui";
    license = licenses.mit;
    maintainers = with maintainers; [ xavierzwirtz ];
    platforms = platforms.all;
  };
}
