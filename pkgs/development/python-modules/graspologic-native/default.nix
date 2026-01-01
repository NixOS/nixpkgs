{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "graspologic-native";
<<<<<<< HEAD
  version = "1.2.5";
=======
  version = "1.2.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "graspologic-org";
    repo = "graspologic-native";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-JIFg+JIxRKXgWLAGgOyKZTe2gXa8wZW5pEubTBLqwmQ=";
=======
    hash = "sha256-fgiBUzYBerYX59uj+I0Yret94vA+FpQK+MckskCBqj4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  buildAndTestSubdir = "packages/pyo3";

  nativeBuildInputs = [ rustPlatform.cargoSetupHook ];

  buildInputs = [ libiconv ];

  build-system = [ rustPlatform.maturinBuildHook ];

  pythonImportsCheck = [ "graspologic_native" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    cd packages/pyo3
  '';

<<<<<<< HEAD
  meta = {
    description = "Library of rust components to add additional capability to graspologic a python library for intelligently building networks and network embeddings, and for analyzing connected data";
    homepage = "https://github.com/graspologic-org/graspologic-native";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
=======
  meta = with lib; {
    description = "Library of rust components to add additional capability to graspologic a python library for intelligently building networks and network embeddings, and for analyzing connected data";
    homepage = "https://github.com/graspologic-org/graspologic-native";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
