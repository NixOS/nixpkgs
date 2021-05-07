{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "aws-c-common";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rGv+fa+UF/f6mY8CmZpkjP98CAcAQCTjL3OI7HsUHcU=";
  };

  # It disables it with MSVC, but CMake doesn't realize that clang for windows,
  # even with gcc-style flags, has the same semantic restrictions.
  patches = stdenv.lib.optional
    (stdenv.hostPlatform.isWindows && stdenv.hostPlatform.useLLVM or false)
    ./no-fpic.patch;

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # for tests
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin
    "-Wno-nullability-extension -Wno-typedef-redefinition";

  doCheck = true;

  meta = with lib; {
    description = "AWS SDK for C common core";
    homepage = "https://github.com/awslabs/aws-c-common";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ orivej eelco r-burns ];
  };
}
