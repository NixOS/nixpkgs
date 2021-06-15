{ lib, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "bottle";
  version = "0.12.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a9d73ffcbc6a1345ca2d7949638db46349f5b2b77dac65d6494d45c23628da2c";
  };

  propagatedBuildInputs = [ setuptools ];

  meta = with lib; {
    homepage = "http://bottlepy.org";
    description = "A fast and simple micro-framework for small web-applications";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ koral ];
  };
}
