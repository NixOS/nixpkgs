{ stdenv, fetchFromGitHub, cmake, curl }: 

stdenv.mkDerivation rec {
  name = "curlcpp-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "JosephP91";
    repo = "curlcpp";
    rev = "${version}";
    sha256 = "1akibhrmqsy0dlz9lq93508bhkh7r1l0aycbzy2x45a9gqxfdi4q";
  };

  buildInputs = [ cmake curl ];

  meta = with stdenv.lib; {
    homepage = "http://josephp91.github.io/curlcpp/";
    description = "Object oriented C++ wrapper for CURL";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ juliendehos rszibele ];
  };
}

