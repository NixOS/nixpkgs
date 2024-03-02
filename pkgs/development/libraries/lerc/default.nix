{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
}:

stdenv.mkDerivation rec {
  pname = "lerc";
  version = "4.0.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "esri";
    repo = "lerc";
    rev = "v${version}";
    hash = "sha256-IHY9QtNYsxPz/ksxRMZGHleT+/bawfTYNVRSTAuYQ7Y=";
  };

  patches = [
    # https://github.com/Esri/lerc/pull/227
    (fetchpatch {
      name = "use-cmake-install-full-dir.patch";
      url = "https://github.com/Esri/lerc/commit/5462ca7f7dfb38c65e16f5abfd96873af177a0f8.patch";
      hash = "sha256-qaNR3QwLe0AB6vu1nXOh9KhlPdWM3DmgCJj4d0VdOUk=";
    })
  ];

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
