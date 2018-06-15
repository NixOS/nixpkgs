{ stdenv, buildPythonPackage, fetchPypi
, requests }:

buildPythonPackage rec {
  pname = "python-pushover";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xlghiqd9rsgn7jdhc8v1xh3xspssihrw1vyy85gvjzxa1ah19sk";
  };

  propagatedBuildInputs = [ requests ];

  # tests require network
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Bindings and command line utility for the Pushover notification service";
    homepage = https://github.com/Thibauth/python-pushover;
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
