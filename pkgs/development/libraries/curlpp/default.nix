{ stdenv, fetchFromGitHub, cmake, curl }:

stdenv.mkDerivation rec {
  name = "curlpp-${version}";
  version = "0.8.1";
  src = fetchFromGitHub {
    owner = "jpbarrette";
    repo = "curlpp";
    rev = "v${version}";
    sha256 = "1b0ylnnrhdax4kwjq64r1fk0i24n5ss6zfzf4hxwgslny01xiwrk";
  };

  buildInputs = [ curl ];
  nativeBuildInputs = [ cmake ];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.curlpp.org/;
    description = "C++ wrapper around libcURL";
    license = licenses.mit;
    maintainers = with maintainers; [ CrazedProgrammer ];
  };
}
