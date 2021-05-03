{ lib, isPy3k, fetchFromGitHub, buildPythonPackage
, attrs, atpublic }:

buildPythonPackage rec {
  pname = "aiosmtpd";
  version = "1.4.2";
  disabled = !isPy3k;

  # Release not published to Pypi
  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = version;
    sha256 = "0hbpyns1j1fpvpj7gyb8cz359j7l4hzfqbig74xp4xih59sih0wj";
  };

  propagatedBuildInputs = [
    atpublic attrs
  ];

  # Tests need network access
  doCheck = false;

  meta = with lib; {
    homepage = "https://aiosmtpd.readthedocs.io/en/latest/";
    description = "Asyncio based SMTP server";
    longDescription = ''
      This is a server for SMTP and related protocols, similar in utility to the
      standard library's smtpd.py module, but rewritten to be based on asyncio for
      Python 3.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
