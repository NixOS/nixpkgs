{ lib, stdenv, fetchFromGitHub, cmake, libminc, netpbm }:

stdenv.mkDerivation rec {
  pname = "bicpl";
  version = "unstable-2020-10-15";

  # current master is significantly ahead of most recent release, so use Git version:
  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = pname;
    rev    = "a58af912a71a4c62014975b89ef37a8e72de3c9d";
    sha256 = "0iw0pmr8xrifbx5l8a0xidfqbm1v8hwzqrw0lcmimxlzdihyri0g";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libminc netpbm ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/cmake" ];

  doCheck = false;
  # internal_volume_io.h: No such file or directory

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/bicpl";
    description = "Brain Imaging Centre programming library";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = with licenses; [ hpndUc gpl3Plus ];
  };
}
