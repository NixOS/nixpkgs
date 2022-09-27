{ buildPythonPackage
, fetchPypi
, lib
, packaging
, pytestCheckHook
, pytorch
}:

buildPythonPackage rec {
  pname = "kornia";
  version = "0.6.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-f/V8kxVRoaFGWqrB+mhCoqrWUPUaD5v2zwsPfW5ftZw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  checkInputs = [
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    packaging
    pytorch
  ];

  # pytest.ini is not published to pypi
  doCheck = false;

  pythonImportsCheck = ["kornia"];

  meta = with lib; {
    description = "Differentiable computer vision library for PyTorch";
    homepage = "https://kornia.readthedocs.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ rehno-lindeque ];
  };
}
