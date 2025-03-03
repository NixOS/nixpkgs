{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  scikit-build-core,
  nanobind,
  cmake,
  pytestCheckHook,
  ninja,
}:

buildPythonPackage rec {
  pname = "pydemumble";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pydemumble";
    tag = "v${version}";
    hash = "sha256-mRqwwuof7f6cdCUYUYoF4fodGcicUFVV8IU88vAK5xw=";
    fetchSubmodules = true;
    postFetch = ''
      # de-vendor nanobind
      rm -rf $out/src/nanobind
    '';
  };

  postPatch = ''
    ln -s ${nanobind.src} src/nanobind
  '';

  build-system = [
    scikit-build-core
    nanobind
  ];

  dontUseCmakeConfigure = true;
  nativeBuildInputs = [
    cmake
    ninja
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/" ];

  pythonImportsCheck = [ "pydemumble" ];

  meta = {
    description = "demumble wrapper library";
    longDescription = ''
      Python wrapper library for demumble; demumble is a tool to
      demangle C++, Rust, and Swift symbol names.
    '';
    homepage = "https://github.com/angr/pydemumble";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
