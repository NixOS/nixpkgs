{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, pytest-mock }:

buildPythonPackage rec {
  pname = "Pykka";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b9d2363365b3455a0204bf163f09bd351d24b938c618c79d975a9510e128e95";
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
