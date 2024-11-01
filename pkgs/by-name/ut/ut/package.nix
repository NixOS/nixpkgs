{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ut";
  version = "2.1.0";

  cmakeFlags = [
    "-DBOOST_UT_ALLOW_CPM_USE=OFF"
  ];

  src = fetchFromGitHub {
    owner = "boost-ext";
    repo = "ut";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pO6tNliAbX1GxYdD6Y+koFUzcvPFrx7s6B0mM6soQM0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  meta = with lib; {
    description = "UT: C++20 μ(micro)/Unit Testing Framework";
    homepage = "https://github.com/boost-ext/ut";
    license = licenses.boost;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.all;
  };
})

