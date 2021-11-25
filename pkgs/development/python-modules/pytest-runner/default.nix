{ lib, buildPythonPackage, fetchPypi, setuptools-scm, pytest }:

buildPythonPackage rec {
  pname = "pytest-runner";
  version = "5.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fce5b8dc68760f353979d99fdd6b3ad46330b6b1837e2077a89ebcf204aac91";
  };

  nativeBuildInputs = [ setuptools-scm pytest ];

  postPatch = ''
    rm pytest.ini
  '';

  checkPhase = ''
    py.test tests
  '';

  # Fixture not found
  doCheck = false;

  meta = with lib; {
    description = "Invoke py.test as distutils command with dependency resolution";
    homepage = "https://github.com/pytest-dev/pytest-runner";
    license = licenses.mit;
  };
}
