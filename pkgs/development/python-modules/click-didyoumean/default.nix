{ lib, buildPythonPackage, fetchPypi,
  click
}:

buildPythonPackage rec {
  pname = "click-didyoumean";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f184f0d851d96b6d29297354ed981b7dd71df7ff500d82fa6d11f0856bee8035";
  };

  propagatedBuildInputs = [ click ];

  meta = with lib; {
    description = "Enable git-like did-you-mean feature in click";
    homepage = "https://github.com/click-contrib/click-didyoumean";
    license = licenses.mit;
    maintainers = with maintainers; [ mbode ];
  };
}
