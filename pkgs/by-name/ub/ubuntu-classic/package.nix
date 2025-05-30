{
  lib,
  stdenvNoCC,
  fetchgit,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ubuntu-classic";
  version = "0.83-6ubuntu2";

  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/fonts-ubuntu-classic";
    rev = "import/${finalAttrs.version}";
    hash = "sha256-GrpBVgisVu7NklFYqkEqYi0hui/pCHlsM3Ky4mEUq90=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype/ubuntu *.ttf

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "import/"; };

  meta = with lib; {
    description = "Ubuntu Classic font";
    longDescription = "The Ubuntu typeface has been specially
    created to complement the Ubuntu tone of voice. It has a
    contemporary style and contains characteristics unique to
    the Ubuntu brand that convey a precise, reliable and free attitude.";
    homepage = "https://design.ubuntu.com/font";
    changelog = "https://git.launchpad.net/ubuntu/+source/fonts-ubuntu-classic/tree/FONTLOG.txt?h=${finalAttrs.src.rev}";
    license = licenses.ufl;
    platforms = platforms.all;
    maintainers = with maintainers; [ bobby285271 ];
  };
})
