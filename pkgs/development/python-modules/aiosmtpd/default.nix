{ lib, isPy3k, fetchPypi, buildPythonPackage
, atpublic }:

buildPythonPackage rec {
  pname = "aiosmtpd";
  version = "1.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xdfk741pjmz1cm8dsi4n5vq4517i175rm94696m3f7kcgk7xsmp";
  };

  propagatedBuildInputs = [
    atpublic
  ];

  # Tests need network access
  doCheck = false;

  meta = with lib; {
    homepage = https://aiosmtpd.readthedocs.io/en/latest/;
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
