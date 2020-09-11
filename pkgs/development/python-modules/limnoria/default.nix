{ stdenv
, buildPythonPackage
, fetchPypi
, isPy27
, pkgs
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2020.07.01";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "08q8krq8dqlvzz3wjgnki3n8d8qmk99pn7n3lfsim5rnrnx1jchb";
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
