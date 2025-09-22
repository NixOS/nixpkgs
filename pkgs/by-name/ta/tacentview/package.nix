{
  autoPatchelfHook,
  cmake,
  fetchFromGitHub,
  installShellFiles,
  lib,
  libGL,
  ninja,
  stdenv,
  tacent,
  xorg,
  zenity,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tacentview";
  version = "1.0.46";

  src = fetchFromGitHub {
    owner = "bluescan";
    repo = "tacentview";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d4A26p1hmkYEZ+h6kRbHHr4QmAc3PMe3qYdkeKIRGkU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    installShellFiles
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    tacent
    xorg.libX11
    xorg.libxcb
    zenity
  ];

  runtimeDependencies = [ libGL ];

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_TACENT" "${tacent.src}")
    (lib.cmakeBool "PACKAGE_NIX" true)
  ];

  installPhase = ''
    runHook preInstall

    installBin tacentview

    mkdir -p $out/share/tacentview
    cp -r ../Assets $out/share/tacentview/
    cp -r ../Linux/deb_template/usr/share/icons $out/share
    cp -r ../Linux/deb_template/usr/share/applications $out/share

    runHook postInstall
  '';

  meta = {
    description = "Image and texture viewer";
    homepage = "https://github.com/bluescan/tacentview";
    changelog = "https://github.com/bluescan/tacentview/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ PopeRigby ];
    mainProgram = "tacentview";
    platforms = with lib.platforms; linux ++ windows;
  };
})
