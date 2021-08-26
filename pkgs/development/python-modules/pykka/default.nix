{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pytest-mock }:

buildPythonPackage rec {
  pname = "Pykka";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da59f77bc6a70e01996259da806d09b0dbc00dabe874ca9558fd5eb1698709c9";
  };

  checkInputs = [ pytestCheckHook pytest-mock ];

  meta = with lib; {
    homepage = "https://www.pykka.org/";
    description = "A Python implementation of the actor model";
    changelog = "https://github.com/jodal/pykka/blob/v${version}/docs/changes.rst";
    maintainers = [ maintainers.marsam ];
    license = licenses.asl20;
  };
}
