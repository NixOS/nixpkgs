{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  meson-python,
  numpy,
  pybind11,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "meshpy";
  version = "2026.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "meshpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mqkhCsozS2PkmIiLIS8A7vZXpESDsiIF5hC90m0QO64=";
  };

  build-system = [
    meson-python
    numpy
    pybind11
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # avoid import shadow
    rm -r meshpy
  '';

  pytestFlags = [
    "./test"
  ];

  pythonImportsCheck = [ "meshpy" ];

  meta = {
    description = "2D/3D simplicial mesh generator interface";
    homepage = "https://github.com/inducer/meshpy/";
    license = with lib.licenses; [
      unfree # Triangle License
      agpl3Plus # TetGen License
      mit # Wrapper licenses
    ];
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
