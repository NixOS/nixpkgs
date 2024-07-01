{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, setuptools, python-dateutil, pygeoif_0_7 }:

buildPythonPackage rec {
  pname = "fastkml";
  version = "0.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NNjrL3e1VAAnQ7uL5WePidjs6lpk3tFIACj0NAXYtjg=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ python-dateutil pygeoif_0_7 ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/cleder/fastkml";
    description = "Fast KML processing for python";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ matrss ];
  };
}
