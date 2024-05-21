{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation {
  pname = "quadprogpp";
  version = "unstable-2023-01-20";

  src = fetchFromGitHub {
    owner = "liuq";
    repo = "QuadProgpp";
    rev = "4c51d91deb5af251957edf9454bfb74279a4544e";
    hash = "sha256-uozwuTAOPsRwYM9KyG3V0hwcmaPpfZPID9Wdd4olsvY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "A C++ library for Quadratic Programming";
    longDescription = ''
      QuadProg++ is a C++ library for Quadratic Programming which implements
      the Goldfarb-Idnani active-set dual method.
    '';
    homepage = "https://github.com/liuq/QuadProgpp";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.all;
  };
}
