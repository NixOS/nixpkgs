{ stdenv, fetchFromGitHub, curl, cmake, nlohmann_json }:

stdenv.mkDerivation rec {
  name = "cpp-ipfs-api-${version}";
  version = "2017-01-04";

  src = fetchFromGitHub {
    owner = "vasild";
    repo = "cpp-ipfs-api";
    rev = "96a890f4518665a56581a2a52311eaa65928eac8";
    sha256 = "1z6gbd7npg4pd9wmdyzcp9h12sg84d7a43c69pp4lzqkyqg8pz1g";
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
