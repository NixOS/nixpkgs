{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "sokol";
  version = "unstable-2023-08-04";

  src = fetchFromGitHub {
    owner = "floooh";
    repo = "sokol";
    rev = "47d92ff86298fc96b3b84d93d0ee8c8533d3a2d2";
    sha256 = "sha256-TsM5wK9a2ectrAY8VnrMPaxCNV3e1yW92SBBCHgs+0k=";
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
