{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm, pytest }:

buildPythonPackage rec {
  pname = "pytest-runner";
  version = "5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25a013c8d84f0ca60bb01bd11913a3bcab420f601f0f236de4423074af656e7a";
  };

  nativeBuildInputs = [ setuptools_scm pytest ];

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
