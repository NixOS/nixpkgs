{ lib
, buildPythonPackage
, fetchPypi
, configparser
, pytest
, isPy3k
, isPy27
}:

buildPythonPackage rec {
  pname = "entrypoints";
  version = "0.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2d587dde06f99545fb13a383d2cd336a8ff1f359c5839ce3a64c917d10c029f";
  };

  checkInputs = [ pytest ];

  propagatedBuildInputs = lib.optional (!isPy3k) configparser;

  checkPhase = let
    # On python2 with pytest 3.9.2 (not with pytest 3.7.4) the test_bad
    # test fails. It tests that a warning (exectly one) is thrown on a "bad"
    # path. The pytest upgrade added some warning, resulting in two warnings
    # being thrown.
    # upstream: https://github.com/takluyver/entrypoints/issues/23
    pyTestArgs = if isPy27 then "-k 'not test_bad'" else "";
  in ''
    py.test ${pyTestArgs} tests
  '';

  meta = {
    description = "Discover and load entry points from installed packages";
    homepage = https://github.com/takluyver/entrypoints;
    license = lib.licenses.mit;
  };
}
