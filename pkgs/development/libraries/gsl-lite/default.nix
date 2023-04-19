{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, installCompatHeader ? false
, installLegacyHeaders ? false
}:

stdenv.mkDerivation rec {
  pname = "gsl-lite";
  version = "0.41.0";

  src = fetchFromGitHub {
    owner = "gsl-lite";
    repo = "gsl-lite";
    rev = "v${version}";
    hash = "sha256-cuuix302bVA7dWa7EJoxJ+otf1rSzjWQK8DHJsVkQio=";
  };

  nativeBuildInputs = [ cmake ninja ];

  cmakeFlags = lib.mapAttrsToList
    (name: value: ''-DGSL_LITE_OPT_${name}:BOOL=${if value then "ON" else "OFF"}'')
    {
      INSTALL_COMPAT_HEADER = installCompatHeader;
      INSTALL_LEGACY_HEADERS = installLegacyHeaders;
      BUILD_TESTS = doCheck;
    };

  # Building tests is broken on Darwin.
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = ''
      A single-file header-only version of ISO C++ Guidelines Support Library
      (GSL) for C++98, C++11, and later
    '';
    longDescription = ''
      gsl-lite is a single-file header-only implementation of the C++ Core
      Guidelines Support Library originally based on Microsoft GSL and adapted
      for C++98, C++03. It also works when compiled as C++11, C++14, C++17,
      C++20.
    '';
    homepage = "https://github.com/gsl-lite/gsl-lite";
    changelog = "https://github.com/gsl-lite/gsl-lite/blob/${src.rev}/CHANGES.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.all;
  };
}
