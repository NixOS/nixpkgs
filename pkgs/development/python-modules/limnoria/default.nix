{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pkgs
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2021.03.18";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "c97e740432bc9244333c49d2f243816b2a61bcdf1ec2280dd5ead16bf47b173a";
  };

  patchPhase = ''
    sed -i 's/version=version/version="${version}"/' setup.py
  '';
  buildInputs = [ pkgs.git ];

  doCheck = false;

  meta = with lib; {
    description = "A modified version of Supybot, an IRC bot";
    homepage = "https://github.com/ProgVal/Limnoria";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
  };

}
