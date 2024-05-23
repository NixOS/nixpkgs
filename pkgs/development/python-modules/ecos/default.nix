{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nose,
  numpy,
  pythonOlder,
  scipy,
}:

buildPythonPackage rec {
  pname = "ecos";
  version = "2.0.11";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "embotech";
    repo = "ecos-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-jflmXR7fuGRSyI6NoQrHFvkKqF/D4iq47StNSCdLbqQ=";
    fetchSubmodules = true;
  };

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  nativeCheckInputs = [ nose ];

  checkPhase = ''
    cd ./src
    nosetests test_interface.py test_interface_bb.py
  '';

  pythonImportsCheck = [ "ecos" ];

  meta = with lib; {
    description = "Python interface for ECOS";
    homepage = "https://github.com/embotech/ecos-python";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
