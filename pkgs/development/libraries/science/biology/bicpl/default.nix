{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libminc,
  netpbm,
}:

stdenv.mkDerivation rec {
  pname = "bicpl";
  version = "unstable-2023-01-19";

  # master is not actively maintained, using develop and develop-apple branches
  src = fetchFromGitHub {
    owner = "BIC-MNI";
    repo = pname;
    rev = "884b3ac8db945a17df51a325d29f49b825a61c3e";
    hash = "sha256-zAA+hPwjMawQ1rJuv8W30EqKO+AI0aq9ybquBnKlzC0=";
  };

  patches = [
    # fixes build by including missing time.h header
    (fetchpatch {
      url = "https://github.com/RaghavSood/bicpl/commit/3def4acd6bae61ff7a930ef8422ad920690382a6.patch";
      hash = "sha256-VdAKuLWTZY7JriK1rexIiuj8y5ToaSEJ5Y+BbnfdYnI=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libminc
    netpbm
  ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib/cmake" ];

  doCheck = false;
  # internal_volume_io.h: No such file or directory

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/bicpl";
    description = "Brain Imaging Centre programming library";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license = with licenses; [
      hpndUc
      gpl3Plus
    ];
  };
}
