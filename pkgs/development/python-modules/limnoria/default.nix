{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, git
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2021.11.20";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "da9c33497a09b4ed0cff6ed44954bbde6cb317edb68d56c73ef235128a802c11";
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
