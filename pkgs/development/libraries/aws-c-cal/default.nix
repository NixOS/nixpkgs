{ lib, stdenv, fetchFromGitHub, cmake, aws-c-common, openssl, Security }:

stdenv.mkDerivation rec {
  pname = "aws-c-cal";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "04acra1mnzw9q7jycs5966akfbgnx96hkrq90nq0dhw8pvarlyv6";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-common openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

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
