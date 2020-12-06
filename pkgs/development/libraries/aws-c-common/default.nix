{ lib, stdenv, fetchFromGitHub, cmake, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "aws-c-common";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0a7hi4crnc3j1j39qcnd44zqdfwzw1xghcf80marx5vdf1qdzy6p";
  };

  nativeBuildInputs = [ cmake ];

  # can be removed once https://github.com/awslabs/aws-c-common/pull/735 gets merged, and version bumped
  patches = [
    (fetchpatch {
      name = "fix-re-export-of-target.patch";
      url = "https://github.com/awslabs/aws-c-common/pull/735/commits/3fca5c629ce0c4d66f50f7152685f3fe73941cb4.patch";
      sha256 = "056f9kyg1c4lwjq8n0r28w1n3zbwrwpi1wbqabk99gaayg46x35a";
    })
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin
    "-Wno-nullability-extension -Wno-typedef-redefinition";

  meta = with lib; {
    description = "AWS SDK for C common core";
    homepage = "https://github.com/awslabs/aws-c-common";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
