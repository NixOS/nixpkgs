{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2018.09.09";

  src = fetchPypi {
    inherit pname version;
    sha256 = "077v4gsl0fimsqxir1mpzn2kvw01fg6fa0nnf33nlfa0xzdn241y";
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
