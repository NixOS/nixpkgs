{ lib
, buildPythonPackage
, fetchPypi
, h5py
, nose
}:

buildPythonPackage rec {
  version = "1.17.0";
  pname = "annoy";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9891e264041d1dcf3af42f67fbb16cb273c5404bc8c869d0915a3087f71d58dd";
  };

  nativeBuildInputs = [ h5py ];

  checkInputs = [
    nose
  ];

  meta = with lib; {
    description = "Approximate Nearest Neighbors in C++/Python optimized for memory usage and loading/saving to disk";
    homepage = "https://github.com/spotify/annoy";
    license = licenses.asl20;
    maintainers = with maintainers; [ timokau ];
  };
}
