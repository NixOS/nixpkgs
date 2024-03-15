{ stdenv
, lib
, fetchFromGitHub
, cmake
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libajantv2";
  version = "17.0.1";

  src = fetchFromGitHub {
    owner = "aja-video";
    repo = "libajantv2";
    rev = "ntv2_${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-brrfjdOEQxBw65Mrwyb5Xvfu/3F930wArV3zmidEiOI=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  meta = with lib; {
    description = "AJA NTV2 Open Source Static Libs and Headers for building applications that only wish to statically link against";
    homepage = "https://github.com/aja-video/libajantv2";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ sebtm ];
    platforms = platforms.linux;
  };
}
