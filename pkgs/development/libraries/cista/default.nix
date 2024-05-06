{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "cista";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "felixguendling";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+DcxnckoXVSc+gXt21fxKkx4J1khLsQPuxYH9CBRrfE=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCISTA_INSTALL=ON" ];

  meta = with lib; {
    homepage = "https://cista.rocks";
    description = "A simple, high-performance, zero-copy C++ serialization & reflection library";
    license = licenses.mit;
    maintainers = [ maintainers.sigmanificient ];
    platforms = platforms.all;
  };
}
