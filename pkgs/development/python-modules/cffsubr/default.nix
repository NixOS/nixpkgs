{
  lib,
  afdko,
  buildPythonPackage,
  cmake,
  distutils,
  fetchPypi,
  fonttools,
  ninja,
  pytestCheckHook,
  scikit-build,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "cffsubr";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d0UVC9uBZ5+s3RHB87hwlsT029SVfo/Ou4jEVoeVLvs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'afdko_output_dir = os.path.join(afdko_root_dir, "build", "bin")' \
                     'afdko_output_dir = "${lib.getBin afdko}/bin"' \
      --replace-fail 'build_cmd=build_release_cmd' 'build_cmd="true"'
  '';

  build-system = [
    cmake
    distutils
    ninja
    scikit-build
    setuptools
    setuptools-scm
  ];

  dontUseCmakeConfigure = true;

  dependencies = [ fonttools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cffsubr" ];

  meta = with lib; {
    changelog = "https://github.com/adobe-type-tools/cffsubr/releases/tag/v${version}";
    description = "Standalone CFF subroutinizer based on AFDKO tx";
    mainProgram = "cffsubr";
    homepage = "https://github.com/adobe-type-tools/cffsubr";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
