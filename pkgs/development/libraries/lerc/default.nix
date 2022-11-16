{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "lerc";
  version = "3.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "esri";
    repo = "lerc";
    rev = "v${version}";
    hash = "sha256-QO5+ouQy5nOcAgvxMeBDoSBP+G3ClDjXipnkuSIDcP0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "C++ library for Limited Error Raster Compression";
    homepage = "https://github.com/esri/lerc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
