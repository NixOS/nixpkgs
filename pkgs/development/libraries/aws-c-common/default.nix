{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  pname = "aws-c-common";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rd2qzaa9mmn5f6f2bl1wgv54f17pqx3vwyy9f8ylh59qfnilpmg";
  };

  patches = [
    # Remove once https://github.com/awslabs/aws-c-common/pull/764 is merged
    (fetchpatch {
      url = "https://github.com/awslabs/aws-c-common/commit/4f85fb3e398d4e4d320d3559235267b26cbc9531.patch";
      sha256 = "1jg3mz507w4kwgmg57kvz419gvw47pd9rkjr6jhsmvardmyyskap";
    })
  ];

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
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco r-burns ];
  };
}
