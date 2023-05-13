{ lib, stdenvNoCC, fetchzip }:

let
  version = "1.0.0";
in
stdenvNoCC.mkDerivation {
  pname = "intel-one-mono";
  inherit version;

  src = fetchzip {
    url ="https://github.com/intel/intel-one-mono/releases/download/V${version}/ttf.zip";
    hash = "sha256-4XE4HS25TlwXzAh41WJS3d7T2U/qO3Hm4zlvMcgEnpU=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cd ttf
    cp *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Intel One Mono font repository";
    longDescription = ''
      an expressive monospaced font family that’s built with clarity, legibility, and the needs of developers in mind.
    '';
    homepage = "https://github.com/intel/intel-one-mono";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [];
  };
}
