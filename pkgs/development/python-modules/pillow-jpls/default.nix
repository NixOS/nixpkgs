{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchPypi
, fetchpatch
, pythonOlder
, pytestCheckHook
, cmake
, ninja
, scikit-build-core
, charls
, eigen
, fmt
, numpy
, pillow
, pybind11
, setuptools
, pathspec
, pyproject-metadata
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pillow-jpls";
  version = "1.3.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "planetmarshall";
    repo = "pillow-jpls";
    rev = "refs/tags/v${version}";
    hash = "sha256-Rc4/S8BrYoLdn7eHDBaoUt1Qy+h0TMAN5ixCAuRmfPU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace '"conan~=2.0.16",' ""
  '';

  nativeBuildInputs = [
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
  propagatedBuildInputs = [
    numpy
    pillow
    pathspec
    pyproject-metadata
  ];

  pypaBuildFlags = [ "-C" "cmake.args='--preset=sysdeps'" ];
  dontUseCmakeConfigure = true;

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  checkInputs = [
    pytestCheckHook
  ];
  # prevent importing from build during test collection:
  preCheck = ''rm -rf pillow_jpls'';

  pythonImportsCheck = [
    "pillow_jpls"
  ];

  meta = with lib; {
    description = "A JPEG-LS plugin for the Python Pillow library";
    homepage = "https://github.com/planetmarshall/pillow-jpls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
