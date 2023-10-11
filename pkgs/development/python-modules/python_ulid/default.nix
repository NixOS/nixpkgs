{ lib
, buildPythonPackage
, fetchPypi
, freezegun
, pytestCheckHook
, hatchling
, hatch-vcs
, hatch-fancy-pypi-readme
, setuptools
}:

let
  pname = "python_ulid";
  version = "2.2.0";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nsd3F305aIDZS+Sax+tK4s1KdHREi/2/6RFTet2XCus=";
  };

  nativeBuildInputs = [ setuptools ];
  buildInputs = [
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

  nativeCheckInputs = [ pytestCheckHook freezegun ];

  meta = with lib; {
    homepage = "https://github.com/mdomke/python-ulid";
    description = "Universally unique lexicographically sortable identifier";
    license = licenses.mit;
    maintainers = with maintainers; [ jfvillablanca ];
  };
}
