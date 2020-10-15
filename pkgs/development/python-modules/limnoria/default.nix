{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, pkgs
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2020.10.10";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "546fdfad14c645ebb56e20a83ce34259b91a6db5c50cf14df741771b28ac2e19";
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
