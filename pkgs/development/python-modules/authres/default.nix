{ stdenv, fetchPypi, openssl, makeWrapper, buildPythonPackage
, pytest, dnspython, pynacl, python }:

buildPythonPackage rec {
  pname = "authres";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mcllhrwr23hwa2jn3m15k29ks1205ymwafjzchh8ma664hnzv6v";
  };

  checkPhase = ''
    # run doctests
    ${python.interpreter} -m authres
  '';

  meta = with stdenv.lib; {
    description = "RFC 5451/7001/7601 Authentication-Results Headers generation and parsing";
    longDescription = ''
      Python module that implements various (proposed) internet standards around email:

      RFC 5617 DKIM/ADSP
      RFC 6008 DKIM signature identification (header.b)
      RFC 6212 Vouch By Reference (VBR)
      RFC 6577 Sender Policy Framework (SPF)
      RFC 7281 Authentication-Results Registration for S/MIME
      RFC 7293 The Require-Recipient-Valid-Since Header Field
      RFC 7489 Domain-based Message Authentication, Reporting, and Conformance (DMARC)
      Authenticated Recieved Chain (ARC) (draft-ietf-dmarc-arc-protocol-08)
'';
    homepage = https://launchpad.net/authentication-results-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ leenaars ];
  };
}
