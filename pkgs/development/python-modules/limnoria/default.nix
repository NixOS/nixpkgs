{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, procps
, chardet
, pytz
, python-dateutil
, python-gnupg
, feedparser
, sqlalchemy
, pysocks
, mock
, cryptography
}:

buildPythonPackage rec {
  pname = "limnoria";
  version = "2021.03.13";
  disabled = isPy27; # abandoned upstream

  src = fetchPypi {
    inherit pname version;
    sha256 = "c13dd7a84eddfcf9c3068d57f3c9da90ea7c0d11688dc3f78f9265f3f093c6ea";
  };

  patchPhase = ''
    sed -i 's/version=version/version="${version}"/' setup.py

    # Unix's test suite assumes /bin/ls and /boot exists
    sed -i 's|/bin/ls|ls|' plugins/Unix/test.py
    sed -i 's|boot|bin|' plugins/Unix/test.py
  '';

  checkInputs = [
    procps
    chardet
    pytz
    python-dateutil
    python-gnupg
    feedparser
    sqlalchemy
    pysocks
    mock
    cryptography
  ];

  checkPhase = ''
    python scripts/supybot-test --no-network test --plugins-dir=./plugins/
  '';

  meta = with lib; {
    description = "A modified version of Supybot, an IRC bot";
    homepage = "https://github.com/ProgVal/Limnoria";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
    broken = stdenv.isDarwin;
  };

}
