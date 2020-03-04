{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "abseil-cpp";
  date = "20191119";
  rev = "8ba96a8244bbe334d09542e92d566673a65c1f78";
  version = "${date}-${rev}";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = rev;
    sha256 = "089bvlspgdgi40fham20qy1m97gr1jh5k5czz49dincpd18j6inb";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "An open-source collection of C++ code designed to augment the C++ standard library";
    homepage = https://abseil.io/;
    license = licenses.asl20;
    maintainers = [ maintainers.andersk ];
  };
}
