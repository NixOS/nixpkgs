{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pkgs
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2020.12.05";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "c4310ea12d1ac39984a96c40a12fab92aefc3d77a615f89ef542b10497ae56fa";
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
