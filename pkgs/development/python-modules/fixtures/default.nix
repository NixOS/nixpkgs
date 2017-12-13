{ lib
, buildPythonPackage
, fetchPypi
, pbr
, testtools
, mock
, python
}:

buildPythonPackage rec {
  pname = "fixtures";
  version = "3.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fcf0d60234f1544da717a9738325812de1f42c2fa085e2d9252d8fff5712b2ef";
  };

  propagatedBuildInputs = [ pbr mock ];

  # cyclic dependency with testtools, see https://github.com/testing-cabal/fixtures/issues/38
  postPatch = ''
    sed -i '/testtools/d' requirements.txt
  '';

  doCheck = false;
  checkInputs = [ testtools ];
  checkPhase = ''
    ${python.interpreter} -m testtools.run fixtures.test_suite
  '';

  meta = {
    description = "Reusable state for writing clean tests and more";
    homepage = "https://pypi.python.org/pypi/fixtures";
    license = lib.licenses.asl20;
  };
}
