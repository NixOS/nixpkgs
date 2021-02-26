{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake }:

stdenv.mkDerivation rec {
  pname = "aws-c-common";
  version = "0.4.64";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-izEZMOPHj/9EL78b/t3M0Tki6eA8eRrpG7DO2tkpf1A=";
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
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin
    "-Wno-nullability-extension -Wno-typedef-redefinition";

  meta = with lib; {
    description = "AWS SDK for C common core";
    homepage = "https://github.com/awslabs/aws-c-common";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
    # https://github.com/awslabs/aws-c-common/issues/754
    broken = stdenv.hostPlatform.isMusl;
  };
}
