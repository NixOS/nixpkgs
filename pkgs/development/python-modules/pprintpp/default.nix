{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pprintpp";
  version = "0.4.0-unstable-2022-05-31";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "joaonc";
    repo = "pprintpp2";
    rev = "303f0652c9420f2cf0a0f4fe1907377508a17b3d"; # no tags
    hash = "sha256-rjOf38m5mzIyJ3aVrD0+WQuzIyFjfa/4zmpFGGhF2hs=";
  };

  patches = [
    # Remove "U" move from open(), https://github.com/wolever/pprintpp/pull/31
    (fetchpatch {
      name = "remove-u.patch";
      url = "https://github.com/wolever/pprintpp/commit/deec5e5efad562fc2f9084abfe249ed0c7dd65fa.patch";
      hash = "sha256-I84pnY/KyCIPPI9q0uvj64t8oPeMkgVTPEBRANkZNa4=";
    })
  ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pprintpp" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Drop-in replacement for pprint that's actually pretty";
    homepage = "https://github.com/wolever/pprintpp";
    changelog = "https://github.com/wolever/pprintpp/blob/${version}/CHANGELOG.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jakewaksbaum ];
    mainProgram = "pypprint";
  };
}
