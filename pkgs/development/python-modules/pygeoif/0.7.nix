{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, setuptools }:

buildPythonPackage rec {
  pname = "pygeoif";
  version = "0.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EaoMBx04vvpK870SPvqDSr4II6hz83RPCgcKRAJa/gQ=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/cleder/pygeoif";
    description = "Basic implementation of the __geo_interface__";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ matrss ];
  };
}
