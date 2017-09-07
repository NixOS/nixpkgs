{ lib
, buildPythonPackage
, fetchPypi
, configparser
, pytest
}:

buildPythonPackage rec {
  pname = "entrypoints";
  version = "0.2.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2d587dde06f99545fb13a383d2cd336a8ff1f359c5839ce3a64c917d10c029f";
  };

  checkInputs = [ pytest];

  propagatedBuildInputs = [ configparser ];

  checkPhase = ''
    py.test tests
  '';

  meta = {
    description = "Discover and load entry points from installed packages";
    homepage = https://github.com/takluyver/entrypoints;
    license = lib.licenses.mit;
  };
}