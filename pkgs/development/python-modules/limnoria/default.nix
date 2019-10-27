{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2019.09.08";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l50smy3hai6pb6lwvcgzrx6yfzshqlvx8ym5my1ji07ilnasmmp";
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
