{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
}:

stdenv.mkDerivation rec {
  pname = "quantlib";
  version = "1.33";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "lballabio";
    repo = "QuantLib";
    rev = "v${version}";
    sha256 = "sha256-j2nRm6ebf5OU6mqmcC7wQf/qlf/K9RmmCAnfT+Au8ZM=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  # Required by RQuantLib, may be beneficial for others too
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
    "QL_HIGH_RESOLUTION_DATE \"Enable date resolution down to microseconds\" OFF" \
    "QL_HIGH_RESOLUTION_DATE \"Enable date resolution down to microseconds\" ON"
  '';

  # Needed for RQuantLib and possible others
  postInstall = ''
    cp ./quantlib-config $out/bin/
  '';

  meta = with lib; {
    description = "A free/open-source library for quantitative finance";
    homepage = "https://quantlib.org";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = [];
  };
}
