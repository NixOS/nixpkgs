{ lib, stdenv, fetchFromGitHub, cmake, aws-c-cal, aws-c-common, s2n-tls, Security }:

stdenv.mkDerivation rec {
  pname = "aws-c-io";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+H6dUKgpgXG1fh8r6k7TpVFMBso4G762zRfLAZD+Nss=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-cal aws-c-common s2n-tls ];
  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_MODULE_PATH=${aws-c-common}/lib/cmake"
  ];

  meta = with lib; {
    description = "AWS SDK for C module for IO and TLS";
    homepage = "https://github.com/awslabs/aws-c-io";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
