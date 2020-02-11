{ stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "NGT";
  version = "v1.8.4";
  nativeBuildInputs = [ cmake ];
  src = fetchFromGitHub {
    owner = "yahoojapan";
    repo = "NGT";
    rev = version;
    sha256 = "f2019e7916b81f8aeabc57d682904c8447776bf9ba94525d20265b329aa43eb5";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/yahoojapan/NGT;
    description = "Nearest Neighbor Search with Neighborhood Graph and Tree for High-dimensional Data";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
    maintainers = with maintainers; [ tomberek ];
  };
}
