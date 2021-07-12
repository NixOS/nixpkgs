{ lib
, buildPythonPackage
, fetchPypi
, python
, six
, pythonOlder
, coverage
}:

buildPythonPackage rec {
  pname = "nose2";
  version = "0.10.0";

  # Requires mock 2.0.0 if python < 3.6, but NixPkgs has mock 3.0.5.
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "886ba617a96de0130c54b24479bd5c2d74d5c940d40f3809c3a275511a0c4a60";
  };

  propagatedBuildInputs = [ six coverage ];

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  meta = with lib; {
    description = "nose2 is the next generation of nicer testing for Python";
    homepage = "https://github.com/nose-devs/nose2";
    license = licenses.bsd0;
  };

}
