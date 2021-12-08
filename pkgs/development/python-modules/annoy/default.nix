{ lib
, buildPythonPackage
, fetchFromGitHub
, h5py
, nose
}:

buildPythonPackage rec {
  version = "1.17.0";
  pname = "annoy";

  src = fetchFromGitHub {
     owner = "spotify";
     repo = "annoy";
     rev = "v1.17.0";
     sha256 = "0s4q2srd3fqinjklcp7mg8c6k64vrwyl5m5dy7rdhi2swy03rwcn";
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
