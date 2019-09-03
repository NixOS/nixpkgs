{ stdenv, fetchFromGitHub, cmake, curl }: 

stdenv.mkDerivation rec {
  pname = "curlcpp";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "JosephP91";
    repo = "curlcpp";
    rev = "${version}";
    sha256 = "025qg5hym73xrvyhalv3jgbf9jqnnzkdjs3zwsgbpqx58zyd5bg5";
  };

  buildInputs = [ cmake curl ];

  meta = with stdenv.lib; {
    homepage = https://josephp91.github.io/curlcpp/;
    description = "Object oriented C++ wrapper for CURL";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ juliendehos rszibele ];
  };
}

