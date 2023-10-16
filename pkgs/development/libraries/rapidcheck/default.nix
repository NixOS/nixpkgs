{ lib
, stdenv
, fetchFromGitHub
, cmake
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "rapidcheck";
  version = "unstable-2023-08-15";

  src = fetchFromGitHub {
    owner = "emil-e";
    repo  = "rapidcheck";
    rev   = "1c91f40e64d87869250cfb610376c629307bf77d";
    hash = "sha256-8pBCRM1Tujjp4wLvYA056OQghXF57kewUOQ3DJM/v58=";
  };

  nativeBuildInputs = [ cmake ];

  # Install the extras headers
  postInstall = ''
    cp -r $src/extras $out
    chmod -R +w $out/extras
    rm $out/extras/CMakeLists.txt
    rm $out/extras/**/CMakeLists.txt
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A C++ framework for property based testing inspired by QuickCheck";
    inherit (src.meta) homepage;
    maintainers = with maintainers; [ ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
