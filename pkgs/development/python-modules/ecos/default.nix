{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, numpy
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "ecos";
  version = "2.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "embotech";
    repo = "ecos-python";
    rev = "v${version}";
    sha256 = "sha256-TPxrTyVZ1KXgPoDbZZqXT5+NEIEndg9qepujqFQwK+Q=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  checkInputs = [
    nose
  ];

  checkPhase = ''
    cd ./src
    nosetests test_interface.py test_interface_bb.py
  '';

  pythonImportsCheck = [
    "ecos"
  ];

  meta = with lib; {
    description = "Python package for ECOS: Embedded Cone Solver";
    homepage = "https://github.com/embotech/ecos-python";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
