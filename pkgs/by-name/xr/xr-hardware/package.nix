{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xr-hardware";
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado/utilities";
    repo = "xr-hardware";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-w35/LoozCJz0ytHEHWsEdCaYYwyGU6sE13iMckVdOzY=";
  };

  dontConfigure = true;
  dontBuild = true;

  installTargets = "install_package";
  installFlagsArray = "DESTDIR=${placeholder "out"}";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Hardware description for XR devices";
    homepage = "https://gitlab.freedesktop.org/monado/utilities/xr-hardware";
    license = licenses.boost;
    maintainers = with maintainers; [ Scrumplex ];
    platforms = platforms.linux;
  };
})
