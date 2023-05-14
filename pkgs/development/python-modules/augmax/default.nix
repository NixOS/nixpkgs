{ buildPythonPackage
, einops
, fetchFromGitHub
, jax
, jaxlib
, lib
}:

buildPythonPackage rec {
  pname = "augmax";
  version = "unstable-2022-02-19";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "khdlr";
    repo = pname;
    # augmax does not have releases tagged. See https://github.com/khdlr/augmax/issues/5.
    rev = "3e5d85d6921a1e519987d33f226bc13f61e04d04";
    sha256 = "046n43v7161w7najzlbi0443q60436xv24nh1mv23yw6psqqhx5i";
  };

  propagatedBuildInputs = [ einops jax ];

  # augmax does not have any tests at the time of writing (2022-02-19), but
  # jaxlib is necessary for the pythonImportsCheckPhase.
  nativeCheckInputs = [ jaxlib ];

  pythonImportsCheck = [ "augmax" ];

  meta = with lib; {
    description = "Efficiently Composable Data Augmentation on the GPU with Jax";
    homepage = "https://github.com/khdlr/augmax";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
