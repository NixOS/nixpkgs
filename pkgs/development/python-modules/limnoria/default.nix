{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, git
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2022.1.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b49a94b0d46f4a2a6ebce4dfc49385502a23ae446baebcc880460d4a1ad33fc7";
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
