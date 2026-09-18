{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "wondershaper";
  version = "unstable-2021-10-15";

  src = fetchFromGitHub {
    owner = "magnific0";
    repo = "wondershaper";
    rev = "98792b55c2ebf4ab4cafffb0780e0c4185fdc03d";
    hash = "sha256-kt5f1dA3fSR5Xsuvh6ZvcY/SFeac8P9MAlwSAJ586W0=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src/wondershaper $out/bin
  '';

  meta = with lib; {
    description = "Command-line utility for limiting an adapter's bandwidth";
    homepage = "https://github.com/magnific0/wondershaper/";
    changelog = "https://github.com/magnific0/wondershaper/blob/${src.rev}/ChangeLog";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "wondershaper";
    platforms = platforms.all;
  };
}
