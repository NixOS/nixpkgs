{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2018.12.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6034e324b3a455f042975006a35dd33fa9175115c7302cb53ca9a646f6594bfc";
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
