{ stdenv, fetchFromGitHub, curl, cmake, nlohmann_json }:

stdenv.mkDerivation rec {
  name = "cpp-ipfs-api-${version}";
  version = "2016-11-09";

  src = fetchFromGitHub {
    owner = "vasild";
    repo = "cpp-ipfs-api";
    rev = "46e473e49ede4fd829235f1d4930754d5356a747";
    sha256 = "10c5hmg9857zb0fp262ca4a42gq9iqdyqz7f975cp3qs70x12q08";
  };

  buildInputs = [ cmake curl ];
  propagatedBuildInputs = [ nlohmann_json ];

  meta = with stdenv.lib; {
    description = "IPFS C++ API client library";
    homepage = https://github.com/vasild/cpp-ipfs-api;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
