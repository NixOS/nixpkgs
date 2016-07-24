{ stdenv
, fetchgit
, cmake
, python
}:
stdenv.mkDerivation rec {
  name = "jsoncpp-${version}";
  version = "1.7.2";

  src = fetchgit {
    url = https://github.com/open-source-parsers/jsoncpp.git;
    sha256 = "04w4cfmvyv52rpqhc370ln8rhlsrr515778bixhgafqbp3p4x34k";
    rev = "c8054483f82afc3b4db7efe4e5dc034721649ec8";
  };

  configurePhase = ''
    mkdir -p Build
    pushd Build

    mkdir -p $out
    cmake .. -DCMAKE_INSTALL_PREFIX=$out \
             -DBUILD_SHARED_LIBS=ON \
             -DCMAKE_BUILD_TYPE=Release
  ''; 

  buildInputs = [ cmake python ];

  meta = with stdenv.lib; {
    homepage = https://github.com/open-source-parsers/jsoncpp;
    description = "A C++ library for interacting with JSON.";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
