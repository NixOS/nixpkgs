{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  cmake,
  ninja,
  scikit-build-core,
  charls,
  eigen,
  fmt,
  numpy,
  pillow,
  pybind11,
  setuptools,
  pathspec,
  pyproject-metadata,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pillow-jpls";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "planetmarshall";
    repo = "pillow-jpls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rc4/S8BrYoLdn7eHDBaoUt1Qy+h0TMAN5ixCAuRmfPU=";
  };

  dontUseCmakeConfigure = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"conan~=2.0.16",' "" \
      --replace-fail '"pybind11~=2.11.1",' '"pybind11",'

    # Pillow 13 rejects an explicit "I;16" mode for native uint16 arrays,
    # let Pillow infer the mode from the array in that case
    substituteInPlace test/test_image_formats.py \
      --replace-fail 'Image.fromarray(data, mode)' 'Image.fromarray(data, None if mode == "I;16" else mode)'
  '';

  build-system = [
    cmake
    ninja
    pybind11
    scikit-build-core
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    charls
    eigen
    fmt
  ];

  dependencies = [
    numpy
    pillow
    pathspec
    pyproject-metadata
  ];

  cmakeFlags = [
    "--preset=sysdeps"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Prevent importing from build during test collection:
  preCheck = "rm -rf pillow_jpls";

  pythonImportsCheck = [ "pillow_jpls" ];

  meta = {
    description = "JPEG-LS plugin for the Python Pillow library";
    homepage = "https://github.com/planetmarshall/pillow-jpls";
    changelog = "https://github.com/planetmarshall/pillow-jpls/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
