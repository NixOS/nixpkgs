{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2019.02.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rlv9l1w80n2jpw2yy1g6x83rvldwzkmkafdalxkar32czbi2xv4";
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
