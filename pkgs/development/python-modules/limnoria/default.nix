{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, git
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2021.07.21";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "80ca1db9648e7678f81b373dab04d06025ec6532e68a9be773ddbd159de54e4c";
  };

  postPatch = ''
    sed -i 's/version=version/version="${version}"/' setup.py
  '';
  buildInputs = [ git ];

  # cannot be imported
  doCheck = false;

  meta = with lib; {
    description = "A modified version of Supybot, an IRC bot";
    homepage = "https://github.com/ProgVal/Limnoria";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
  };

}
