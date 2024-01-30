{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "umpire";
  version = "2023.06.0";

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "umpire";
    rev = "v${version}";
    hash = "sha256-gdwr0ACCfkrtlVROPhxM7zT7SaCo2Eg1etrPFN4JHaA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Application-focused API for memory management on NUMA & GPU architectures";
    homepage = "https://github.com/LLNL/Umpire";
    maintainers = with maintainers; [ sheepforce ];
    license = with licenses; [ mit ];
    platforms = [ "x86_64-linux" ];
  };
}
