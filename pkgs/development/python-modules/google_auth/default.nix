{ stdenv, buildPythonPackage, fetchpatch, fetchPypi
, pytest, mock, oauth2client, flask, requests, setuptools, urllib3, pytest-localserver, six, pyasn1-modules, cachetools, rsa, freezegun }:

buildPythonPackage rec {
  pname = "google-auth";
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xs8ch6bz57vs6j0p8061c7wj9ahkvrfpf1y9v7r009979507ckv";
  };

  checkInputs = [ pytest mock oauth2client flask requests urllib3 pytest-localserver freezegun ];
  propagatedBuildInputs = [ six pyasn1-modules cachetools rsa setuptools ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "This library simplifies using Google’s various server-to-server authentication mechanisms to access Google APIs.";
    homepage = "https://google-auth.readthedocs.io/en/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
