{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  aws-c-common,
  nix,
}:

stdenv.mkDerivation rec {
  pname = "aws-checksums";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EhIVa8/IK4evGt4vYECunLpxrCMSOsr1RZ/8hFbRi9M=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ aws-c-common ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  passthru.tests = {
    inherit nix;
  };

  meta = with lib; {
    description = "HW accelerated CRC32c and CRC32";
    homepage = "https://github.com/awslabs/aws-checksums";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      orivej
      eelco
    ];
  };
}
