{ stdenv
, lib
, fetchFromGitLab
, cmake
, openmpi
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "diy";
  version = "unstable-2022-01-04";

  src = fetchFromGitLab {
    domain = "gitlab.kitware.com";
    owner = "diatomic";
    repo = "diy";
    rev = "9246b0bd09368455e8604063a44fe7a93088d789";
    sha256 = "/rKuwRSEcw9AkyfBAhbYF9z//i/iJ/ZoHtLDzJCurEY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    openmpi
  ];

  cmakeFlags = [
    # Slow
    "-Dbuild_examples=OFF"
    # Fails to build with “size of array 'altStackMem' is not an integral constant-expression”
    "-Dbuild_tests=OFF"
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://gitlab.kitware.com/diatomic/diy.git";
    };
  };

  meta = with lib; {
    description = "Data-parallel out-of-core library";
    homepage = "https://gitlab.kitware.com/diatomic/diy";
    license = licenses.bsd3; # Actually BSD-3-Clause-LBNL
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
