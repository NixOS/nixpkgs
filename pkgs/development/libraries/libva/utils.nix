{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libdrm,
  libva,
  libX11,
  libXext,
  libXfixes,
  wayland,
}:

stdenv.mkDerivation rec {
  pname = "libva-utils";
<<<<<<< HEAD
  version = "2.23.0";
=======
  version = "2.22.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libva-utils";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-losxOPCrLCjtRKJ8RuwkjRllYYtJluKhscNfdxpC/xg=";
=======
    sha256 = "sha256-CmhdhNNRO2j8lH7awp9YiKWMvV17GTBsXdrNY06jT2w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libdrm
    libva
    libX11
    libXext
    libXfixes
    wayland
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Collection of utilities and examples for VA-API";
    longDescription = ''
      libva-utils is a collection of utilities and examples to exercise VA-API
      in accordance with the libva project.
    '';
    homepage = "https://github.com/intel/libva-utils";
    changelog = "https://raw.githubusercontent.com/intel/libva-utils/${version}/NEWS";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.unix;
=======
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
