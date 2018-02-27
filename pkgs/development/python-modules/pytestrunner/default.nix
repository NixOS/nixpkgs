{ stdenv, buildPythonPackage, fetchPypi, setuptools_scm, pytest }:

buildPythonPackage rec {
  pname = "pytest-runner";
  version = "4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "183f3745561b1e00ea51cd97634ba5c540848ab4aa8016a81faba7fb7f33ec76";
  };

  buildInputs = [ setuptools_scm pytest ];

  meta = with stdenv.lib; {
    description = "Invoke py.test as distutils command with dependency resolution";
    homepage = https://bitbucket.org/pytest-dev/pytest-runner;
    license = licenses.mit;
  };
}
