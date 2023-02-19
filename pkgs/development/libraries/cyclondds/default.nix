{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "cyclondds";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds";
    rev = version;
    sha256 = "sha256-xr9H9n+gyFMgEMHn59T6ELYVZJ1m8laG0d99SE9k268=";
  };

  patches = [
    ./0001-Use-full-path-in-pkgconfig.patch
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Eclipse Cyclone DDS project";
    homepage = "https://cyclonedds.io/";
    license = with licenses; [ epl20 ];
    maintainers = with maintainers; [ bachp ];
  };
}
