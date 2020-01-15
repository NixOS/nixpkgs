{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "1.15.2";
  pname = "annoy";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i5bkf8mwd1pyrbhfwncir2r8yq8s9qz5j13vv2qz92n9g57sr3m";
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
