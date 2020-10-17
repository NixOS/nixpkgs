{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "abseil-cpp";
  version = "20200923.1";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = version;
    sha256 = "0mc7nvawisiawaizrxirrd3839562fcanswz27wskglbgf2bngsg";
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
