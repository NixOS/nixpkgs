{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm, pytest }:

buildPythonPackage rec {
  pname = "pytest-runner";
  version = "4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d23f117be39919f00dd91bffeb4f15e031ec797501b717a245e377aee0f577be";
  };

  buildInputs = [ setuptools_scm pytest ];

  postPatch = ''
    rm pytest.ini
  '';

  checkPhase = ''
    py.test tests
  '';

  # Fixture not found
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Invoke py.test as distutils command with dependency resolution";
    homepage = https://github.com/pytest-dev/pytest-runner;
    license = licenses.mit;
  };
}
