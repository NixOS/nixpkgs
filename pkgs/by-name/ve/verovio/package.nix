{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  git,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "verovio";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "rism-digital";
    repo = "verovio";
    rev = "version-${finalAttrs.version}";
    hash = "sha256-PjBtnt46pHV3rDlwltVxfUMlgNoZGnI9CfnFtk2/j3s=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    cmake
    git
    makeWrapper
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    cd tools
    patchShebangs .
    cmake ../cmake
    make -j 8

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/

    mv verovio $out/bin
    cp -R $src/data $out/share/verovio

    wrapProgram $out/bin/verovio \
      --add-flags "-r $out/share/verovio"

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = ''
      A fast, portable and lightweight library for engraving Music Encoding Initiative (MEI) digital scores into SVG images.
    '';
    homepage = "https://www.verovio.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tshaynik ];
    platforms = platforms.all;
  };
})
