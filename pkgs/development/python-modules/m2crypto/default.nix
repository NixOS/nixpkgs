{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, swig2
, openssl
, typing
, parameterized
}:


buildPythonPackage rec {
  version = "0.38.0";
  pname = "M2Crypto";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mfImCjCQHJSajcbV+CzVMS/7iryS52YzuvIxu7yy3ss=";
  };

  patches = [
    # Use OpenSSL_version_num() instead of unrealiable parsing of .h file.
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/m2crypto/raw/42951285c800f72e0f0511cec39a7f49e970a05c/f/m2crypto-MR271-opensslversion.patch";
      hash = "sha256-e1/NHgWza+kum76MUFSofq9Ko3pML67PUfqWjcwIl+A=";
    })
    # Changed required to pass tests on OpenSSL 3.0
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/m2crypto/raw/42951285c800f72e0f0511cec39a7f49e970a05c/f/m2crypto-0.38-ossl3-tests.patch";
      hash = "sha256-B6JKoPh76+CIna6zmrvFj50DIp3pzg8aKyzz+Q5hqQ0=";
    })
    # Allow EVP tests fail on non-FIPS algorithms
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/m2crypto/raw/42951285c800f72e0f0511cec39a7f49e970a05c/f/m2crypto-0.38-ossl3-tests-evp.patch";
      hash = "sha256-jMUAphVBQMFaOJSeYUCQMV3WSe9VDQqG6GY5fDQXZnA=";
    })
    # Fix the readline test https://gitlab.com/m2crypto/m2crypto/-/issues/286
    (fetchpatch {
      url = "https://gitlab.com/m2crypto/m2crypto/-/commit/b8addc7ad9990d1ba3786830ebd74aa8c939849d.patch";
      hash = "sha256-M5mrmJVCT0fASvERLKa/MR+EY2hzRGIkyUfguVBPKNk=";
    })
  ];

  nativeBuildInputs = [ swig2 openssl ];
  buildInputs = [ openssl parameterized ];

  meta = with lib; {
    description = "A Python crypto and SSL toolkit";
    homepage = "https://gitlab.com/m2crypto/m2crypto";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
