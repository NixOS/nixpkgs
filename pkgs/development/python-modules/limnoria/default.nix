{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, pkgs
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2020.08.30";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "44d81682cdf246a0324638707a2ef0819aae8c84fc0e69daaaa57cbc3f9e18e1";
  };

  patchPhase = ''
    sed -i 's/version=version/version="${version}"/' setup.py
  '';
  buildInputs = [ pkgs.git ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A modified version of Supybot, an IRC bot";
    homepage = "https://github.com/ProgVal/Limnoria";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
  };

}
