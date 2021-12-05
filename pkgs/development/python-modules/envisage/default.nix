{ lib, fetchPypi, isPy27, buildPythonPackage, traits, apptools, pytestCheckHook
, ipython, setuptools }:

buildPythonPackage rec {
  pname = "envisage";
  version = "6.0.1";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8864c29aa344f7ac26eeb94788798f2d0cc791dcf95c632da8d79ebc580e114c";
  };

  # for the optional dependency ipykernel, only versions < 6 are
  # supported, so it's not included in the tests, and not propagated
  propagatedBuildInputs = [ traits apptools setuptools ];

  preCheck = ''
    export HOME=$PWD/HOME
  '';

  checkInputs = [ ipython pytestCheckHook ];

  meta = with lib; {
    description =
      "Framework for building applications whose functionalities can be extended by adding 'plug-ins'";
    homepage = "https://github.com/enthought/envisage";
    maintainers = with lib.maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
