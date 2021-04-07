{ lib, stdenv, fetchFromGitHub, cmake, aws-c-cal, aws-c-common, aws-c-io, aws-checksums, s2n-tls, libexecinfo }:

stdenv.mkDerivation rec {
  pname = "aws-c-event-stream";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8Du9Ib3MhPcgetBIi0k1NboaXxZh7iPNhDe7197JnHc=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-cal aws-c-common aws-c-io aws-checksums s2n-tls ]
    ++ lib.optional stdenv.hostPlatform.isMusl libexecinfo;

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS:BOOL=ON"
    "-DCMAKE_MODULE_PATH=${aws-c-common}/lib/cmake"
  ];

  meta = with lib; {
    description = "C99 implementation of the vnd.amazon.eventstream content-type";
    homepage = "https://github.com/awslabs/aws-c-event-stream";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej eelco ];
  };
}
