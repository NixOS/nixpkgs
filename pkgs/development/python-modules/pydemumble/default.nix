{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  scikit-build-core,
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
    hash = "sha256-JAUMTOYGHu64L0zLK2dzf0poHrGGiE29WoAR5kRsR+s=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        ', "nanobind >=1.3.2"' \
        ""
  '';

  build-system = [
    scikit-build-core
  ];

  dontUseCmakeConfigure = true;
  nativeBuildInputs = [
    cmake
    ninja
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/" ];

  pythonImportsCheck = [ "pydemumble" ];

  meta = {
    description = "Demumble wrapper library";
    longDescription = ''
      Python wrapper library for demumble; demumble is a tool to
      demangle C++, Rust, and Swift symbol names.
    '';
    homepage = "https://github.com/angr/pydemumble";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
