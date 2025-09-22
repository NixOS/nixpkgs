{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build-system
  pbr,
  setuptools,

  # tests
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "munch";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Infinidat";
    repo = "munch";
    tag = version;
    hash = "sha256-p7DvOGRhkCmtJ32EfttyKXGGmO5kfb2bQGqok/RJtU8=";
  };

  patches = [
    (fetchpatch2 {
      # python3.13 compat
      url = "https://github.com/Infinidat/munch/commit/84651ee872f9ea6dbaed986fd3818202933a8b50.patch";
      hash = "sha256-n/uBAP7pnlGZcnDuxdMKWgAEdG9gWeGoLWB97T1KloY=";
    })
  ];

  env.PBR_VERSION = version;

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  meta = with lib; {
    description = "Dot-accessible dictionary (a la JavaScript objects)";
    license = licenses.mit;
    homepage = "https://github.com/Infinidat/munch";
  };
}
