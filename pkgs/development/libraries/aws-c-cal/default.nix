{ lib, stdenv, fetchFromGitHub, cmake, aws-c-common, openssl, Security, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "aws-c-cal";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "04acra1mnzw9q7jycs5966akfbgnx96hkrq90nq0dhw8pvarlyv6";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/awslabs/aws-c-cal/commit/2169f11aae546e8aa7ed36c91ffc006a4e87aae8.patch";
      sha256 = "16wxydw140s90z0601vn00xqvsn67bj9dfc80c69k8sib1r6901q";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-common openssl ];

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_MODULE_PATH=${aws-c-common}/lib/cmake"
  ];

  meta = with lib; {
    description = "AWS Crypto Abstraction Layer ";
    homepage = "https://github.com/awslabs/aws-c-cal";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
