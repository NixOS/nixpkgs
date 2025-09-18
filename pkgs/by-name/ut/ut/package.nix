{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ut";
  version = "2.3.1";

  cmakeFlags = [
    "-DBOOST_UT_ALLOW_CPM_USE=OFF"
  ];

  src = fetchFromGitHub {
    owner = "boost-ext";
    repo = "ut";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VCTrs0CMr4pUrJ2zEsO8s7j16zOkyDNhBc5zw0rAAZI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  meta = with lib; {
    description = "C++20 μ(micro)/Unit Testing Framework";
    homepage = "https://github.com/boost-ext/ut";
    license = licenses.boost;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.all;
  };
})
