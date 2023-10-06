{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "candy-icons";
  version = "2023-10-03";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "candy-icons";
    rev = "bcf24f3308cc5e39f3e7d1bb43cb26f627f9ba8f";
    sha256 = "sha256-NCXxH04GvrPE5mQO7JrU6SkjA+BaZokhyjKsm8m9p3g=";
  };
  
  installPhase = ''
    mkdir -p $out/share/icons/candy-icons
    cp -r . $out/share/icons/candy-icons
  '';

  meta = with lib; {
    homepage = "https://github.com/EliverLara/candy-icons";
    description = "Sweet gradient icons";
    longDescription = "An icon theme colored with sweet gradients";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ clr-cera ];
  };
}
