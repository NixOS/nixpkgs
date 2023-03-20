{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "nanoleaf";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17dmxibfjmwnrs6ng5cmvfis3cv6iw267xb8n1pijy15y9dz0s8s";
  };

  prePatch = ''
    sed -i '/^gitVersion =/d' setup.py
    substituteInPlace setup.py --replace 'gitVersion' '"${version}"'
  '';

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    description = "A python interface for Nanoleaf Aurora lighting";
    homepage = "https://github.com/software-2/nanoleaf";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
