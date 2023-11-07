{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ut";
  version = "2.0.0";

  cmakeFlags = [
    "-DBOOST_UT_ALLOW_CPM_USE=OFF"
  ];

  src = fetchFromGitHub {
    owner = "boost-ext";
    repo = "ut";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nMRhVtbnORMnZxIdrv6pvfj8/fv/buh4Y7mz0cr4p+E=";
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

