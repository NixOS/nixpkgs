{ buildPythonPackage
, fetchFromGitHub
, lib

# propagated build inputs
, packaging
, pytorch

# check inputs
, pytestCheckHook
, opencv3
, scipy
}:

buildPythonPackage rec {
  pname = "kornia";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "kornia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SWSVGwc6jet5p8Pm3Cz1DR70bhnZDMIwJzFAliOgjoA";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
  '';

  checkInputs = [
    pytestCheckHook
    opencv3
    scipy
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
