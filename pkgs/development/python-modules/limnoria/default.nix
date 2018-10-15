{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2016.05.06";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09kbii5559d09jjb6cryj8rva1050r54dvb67hlcvxhy8g3gr1y3";
  };

  patchPhase = ''
    sed -i 's/version=version/version="${version}"/' setup.py
  '';
  buildInputs = [ pkgs.git ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A modified version of Supybot, an IRC bot";
    homepage = http://supybot.fr.cr;
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
  };

}
