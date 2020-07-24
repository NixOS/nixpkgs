{ lib, isPy3k, fetchFromGitHub, buildPythonPackage
, atpublic }:

buildPythonPackage rec {
  pname = "aiosmtpd";
  version = "1.2.1";
  disabled = !isPy3k;

  # Release not published to Pypi
  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = version;
    sha256 = "14c30dm6jzxiblnsah53fdv68vqhxwvb9x0aq9bc4vcdas747vr7";
  };

  propagatedBuildInputs = [
    atpublic
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
