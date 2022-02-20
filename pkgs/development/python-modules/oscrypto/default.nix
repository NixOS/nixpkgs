{ lib
, stdenv
, buildPythonPackage
, asn1crypto
, fetchPypi
, openssl
}:

buildPythonPackage rec {
  pname = "oscrypto";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1546si2bdgkqnbvv4mw1hr4mhh6bq39d9z4wxgv1m7fq6miclb3x";
  };

  testSources = fetchPypi {
    inherit version;
    pname = "oscrypto_tests";
    sha256 = "1ha68dsrbx6mlra44x0n81vscn17pajbl4yg7cqkk7mq1zfmjwks";
  };

  propagatedBuildInputs = [
    asn1crypto
    openssl
  ];

  preCheck = ''
    tar -xf ${testSources}
    mv oscrypto_tests-${version} tests

    # remove tests that require network
    sed -e '/TLSTests/d' -e '/TrustListTests/d' -i tests/__init__.py
  '';

  pythonImportsCheck = [ "oscrypto" ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Encryption library for Python";
    homepage = "https://github.com/wbond/oscrypto";
    license = licenses.mit;
  };
}
