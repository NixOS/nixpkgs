{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "cyclonedds";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds";
    rev = version;
    sha256 = "sha256-LSCfQPyd/QOsrnLNbKb0OlCvmHi/2aDDhi8VeXpYb1w=";
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
