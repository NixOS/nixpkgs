{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "abseil-cpp";
  version = "20200225.2";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = version;
    sha256 = "0dwxg54pv6ihphbia0iw65r64whd7v8nm4wwhcz219642cgpv54y";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "An open-source collection of C++ code designed to augment the C++ standard library";
    homepage = "https://abseil.io/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.andersk ];
  };
}
