{ lib, buildPythonPackage, fetchPypi, pyyaml }:

buildPythonPackage rec {
  pname = "aspy.yaml";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i9z2jm2hjwdxdv4vw4kbs70h2ciz49rv8w73zbawb7z5qw45iz7";
  };

  propagatedBuildInputs = [ pyyaml ];

  # Tests not included in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "A few extensions to pyyaml";
    homepage = "https://github.com/asottile/aspy.yaml";
    license = licenses.mit;
  };
}
