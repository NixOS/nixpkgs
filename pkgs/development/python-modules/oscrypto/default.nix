{ buildPythonPackage
, asn1crypto
, fetchPypi
, lib
, openssl
}:

buildPythonPackage rec {
  pname = "oscrypto";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vlryamwr442w2av8f54ldhls8fqs6678fg60pqbrf5pjy74kg23";
  };

  testSources = fetchPypi {
    inherit version;
    pname = "oscrypto_tests";
    sha256 = "1crndz647pqdd8148yn3n5l63xwr6qkwa1qarsz59nk3ip0dsyq5";
  };

  preCheck = ''
    tar -xf ${testSources}
    mv oscrypto_tests-${version} tests

    # remove tests that require network
    sed -e '/TLSTests/d' -e '/TrustListTests/d' -i tests/__init__.py
  '';

  propagatedBuildInputs = [
    asn1crypto
    openssl
  ];

  meta = with lib; {
    description = "A compilation-free, always up-to-date encryption library for Python that works on Windows, OS X, Linux and BSD.";
    homepage = "https://www.snowflake.com/";
    license = licenses.mit;
  };
}
