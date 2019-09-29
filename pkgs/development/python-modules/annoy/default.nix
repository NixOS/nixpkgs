{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "1.16.0";
  pname = "annoy";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jnm38kg7aw63mkd5113i3pb2p9fp5cia91jwhyg9sazb45bzpv9";
  };

  checkInputs = [
    nose
  ];

  meta = with stdenv.lib; {
    description = "Approximate Nearest Neighbors in C++/Python optimized for memory usage and loading/saving to disk";
    homepage = https://github.com/spotify/annoy;
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
  };
}
