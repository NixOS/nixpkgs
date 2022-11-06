{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, pyyaml
, msgpack
, pandas
}:

buildPythonPackage rec {
  pname = "tensile";
  rocmVersion = "5.3.1";
  version = "4.34.0-${rocmVersion}";

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "Tensile";
    rev = "rocm-${rocmVersion}";
    hash = "sha256-QWt/zzBrZKM8h3MTnbLX4vN3p6cCQvo67U1C2yqAQxw=";
  };

  buildInputs = [
    pyyaml
    msgpack
    pandas
  ];

  meta = with lib; {
    description = "GEMMs and tensor contractions";
    homepage = "https://github.com/ROCmSoftwarePlatform/Tensile";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ Madouura ];
  };
}
