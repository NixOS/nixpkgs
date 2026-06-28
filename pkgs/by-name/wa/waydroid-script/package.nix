{
  python3,
  waydroid,

  fetchFromGitHub,
  stdenv,
  lib,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "waydroid-script";
  version = "0-unstable-2025-07-13";

  buildInputs = [
    (python3.withPackages (
      ps:
      (with ps; [
        tqdm
        requests
        inquirerpy
      ])
    ))
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchFromGitHub {
    owner = "casualsnek";
    repo = "waydroid_script";
    rev = "3e344b360f64f4a417c4f5e9a3b1aae3da9fdfb9";
    hash = "sha256-l4L11Ilz3Y2lmKceg0+ZROPADgqhOwxzR/8V+ffyTjY=";
  };

  postPatch = ''
    substituteInPlace tools/container.py --replace-fail ' run(["waydroid",' ' run(["${lib.getExe waydroid}",'
    patchShebangs main.py
  '';

  installPhase = ''
    mkdir -p $out/libexec
    cp -r . $out/libexec/waydroid_script
    mkdir -p $out/bin
    ln -s $out/libexec/waydroid_script/main.py $out/bin/${pname}
  '';

  meta = {
    description = "Script to add GApps and other stuff to Waydroid";
    homepage = "https://github.com/casualsnek/waydroid_script";
    mainProgram = "waydroid-script";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ hustlerone ];
  };
}
