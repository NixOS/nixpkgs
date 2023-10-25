{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonAtLeast
, pbr
, testtools
, mock
, python
, six
}:

buildPythonPackage rec {
  pname = "fixtures";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fcf0d60234f1544da717a9738325812de1f42c2fa085e2d9252d8fff5712b2ef";
  };

  patches = lib.optionals (pythonAtLeast "3.9") [
    # drop tests that try to monkeypatch a classmethod, which fails on python3.9
    # https://github.com/testing-cabal/fixtures/issues/44
    (fetchpatch {
       url = "https://salsa.debian.org/openstack-team/python/python-fixtures/-/raw/debian/victoria/debian/patches/remove-broken-monkey-patch-test.patch";
       sha256 = "1s3hg2zmqc4shmnf90kscphzj5qlqpxghzw2a59p8f88zrbsj97r";
    })
  ];

  nativeBuildInputs = [
    pbr
  ];

  propagatedBuildInputs = [
    testtools
    six # not in install_requires, but used in fixture.py
  ];

  nativeCheckInputs = [
    mock
  ];

  checkPhase = ''
    ${python.interpreter} -m testtools.run fixtures.test_suite
  '';

  meta = {
    description = "Reusable state for writing clean tests and more";
    homepage = "https://pypi.python.org/pypi/fixtures";
    license = lib.licenses.asl20;
  };
}
