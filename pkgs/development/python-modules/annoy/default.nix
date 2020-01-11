{ stdenv
, buildPythonPackage
, fetchPypi
, h5py
, nose
}:

buildPythonPackage rec {
  version = "1.16.3";
  pname = "annoy";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe2779664bd8846f2d67191a7e6010b8df890ac4586336748fd0697f31654379";
  };

  nativeBuildInputs = [ h5py ];

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
