{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "1.16.2";
  pname = "annoy";

  src = fetchPypi {
    inherit pname version;
    sha256 = "41348e813fe7125eda3e2229a075eba3d065173ba6c5f20c545bb9c2932633fa";
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
