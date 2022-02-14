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
  version = "0.11.0";

  # Requires mock 2.0.0 if python < 3.6, but NixPkgs has mock 3.0.5.
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bSCNfW7J+dVcdNrIHJOUvDkG2++BqMpUILK5t/jmnek=";
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
