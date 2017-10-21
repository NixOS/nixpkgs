{ stdenv, fetchFromGitHub, cmake }:

let version = "0.7.2"; in
stdenv.mkDerivation {
  name = "libdynd-${version}";

  src = fetchFromGitHub {
    owner = "libdynd";
    repo = "libdynd";
    rev = "v${version}";
    sha256 = "0fkd5rawqni1cq51fmr76iw7ll4fmbahfwv4rglnsabbkylf73pr";
  };

  cmakeFlags = [
    "-DDYND_BUILD_BENCHMARKS=OFF"
  ];

  buildInputs = [ cmake ];

  outputs = [ "out" "dev" ];
  outputDoc = "dev";

  meta = with stdenv.lib; {
    description = "C++ dynamic ndarray library, with Python exposure.";
    homepage = http://libdynd.org;
    license = licenses.bsd2;
  };
}
