{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, numpy
, h5py
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "h5io";
  version = "0.1.9";
  format = "setuptools";

  disable = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "h5io";
    repo = "h5io";
    rev = "h5io-${version}";
    hash = "sha256-ZavcTg2DrapIbT/2NaOEfnwxJd2J5wWsgbxPDJAL+WU=";
  };

  patches = [
    ./disable-pytest-cov.patch
  ];

  propagatedBuildInputs = [
    numpy
    h5py
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "h5io" ];

  meta = with lib; {
    description = "Read and write simple Python objects using HDF5";
    homepage = "https://github.com/h5io/h5io";
    changelog = "https://github.com/h5io/h5io/releases/tag/${src.rev}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
