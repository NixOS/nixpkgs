{
  lib,
  afdko,
  buildPythonPackage,
  cmake,
  distutils_80,
  fetchPypi,
  fonttools,
  ninja,
  pytestCheckHook,
  scikit-build,
  setuptools_80,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "cffsubr";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LDIbaAe9lYVtkh7Z3OhQZJXPSfx6iaY8uULovs4Trd0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'afdko_output_dir = os.path.join(afdko_root_dir, "build", "bin")' \
                     'afdko_output_dir = "${lib.getBin afdko}/bin"' \
      --replace-fail 'build_cmd=build_release_cmd' 'build_cmd="true"'
  '';

  build-system = [
    distutils_80
    setuptools_80
    cmake
    ninja
    scikit-build
    setuptools-scm
  ];

  dontUseCmakeConfigure = true;

  dependencies = [ fonttools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cffsubr" ];

  meta = {
    changelog = "https://github.com/adobe-type-tools/cffsubr/releases/tag/v${version}";
    description = "Standalone CFF subroutinizer based on AFDKO tx";
    mainProgram = "cffsubr";
    homepage = "https://github.com/adobe-type-tools/cffsubr";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
