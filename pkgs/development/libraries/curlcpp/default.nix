{ stdenv, fetchFromGitHub, cmake, curl }: 

stdenv.mkDerivation {
  name = "curlcpp-20160901";

  src = fetchFromGitHub {
    owner = "JosephP91";
    repo = "curlcpp";
    rev = "98286da1d6c9f6158344a8e272eae5030cbf6c0e";
    sha256 = "00nm2b8ik1yvaz5dp1b61jid841jv6zf8k5ma2nxbf1di1apqh0d";
  };

  buildInputs = [ cmake curl ];

  meta = with stdenv.lib; {
    homepage = "http://josephp91.github.io/curlcpp/";
    description = "Object oriented C++ wrapper for CURL";
    platforms = platforms.unix ;
    license = licenses.mit;
    maintainers = [ maintainers.juliendehos ];
  };
}

