{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
}:

stdenv.mkDerivation rec {
  pname = "quantlib";
  version = "1.34";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "lballabio";
    repo = "QuantLib";
    rev = "v${version}";
    sha256 = "sha256-qrMaIBiDg7bFtWTDAQgAMtekb/7VrI7Ix+G59mU4WHI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  # Required by RQuantLib, may be beneficial for others too
  cmakeFlags = [ "-DQL_HIGH_RESOLUTION_DATE=ON" ];

  # Needed for RQuantLib and possible others
  postInstall = ''
    cp ./quantlib-config $out/bin/
  '';

  meta = with lib; {
    description = "Free/open-source library for quantitative finance";
    homepage = "https://quantlib.org";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = [ maintainers.kupac ];
  };
}
