{
  lib,
  stdenvNoCC,
  fetchFromGitLab
}: stdenvNoCC.mkDerivation {
  pname = "xr-hardware";
  version = "unstable-2023-11-08";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado/utilities";
    repo = "xr-hardware";
    rev = "9204de323210d2a5ab8635c2ee52127100de67b1";
    hash = "sha256-ZS15WODms/WKsPu+WbfILO2BOwnxrhCY/SoF8jzOX5Q=";
  };

  installTargets = "install_package";
  installFlagsArray = "DESTDIR=${placeholder "out"}";

  meta = with lib; {
    description = "Hardware description for XR devices";
    homepage = "https://gitlab.freedesktop.org/monado/utilities/xr-hardware";
    license = licenses.boost;
    maintainers = with maintainers; [ Scrumplex ];
    platforms = platforms.linux;
  };
}
