{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  buildPythonPackage,
  matplotlib,
  numpy,
  pillow,
  pyan3,
  pypaBuildHook,
  rich,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fio_plot";
  version = "1.1.16";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "louwrentius";
    repo = "fio-plot";
    tag = "v${version}";
    hash = "sha256-yN0gVm6ZYEIoh91d+0ohJ9yU+VWwYEq3MoG+WgBrs2Q=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/louwrentius/fio-plot/commit/420f46508bf861d5279c9b378ca7b08e39a828f6.patch?full_index=1";
      hash = "sha256-GrKdExbVuvtb+Ru1kGff30WU2RWvSKTu7yl0yk0IZUs=";
    })
  ];

  dependencies = [
    matplotlib
    numpy
    pillow
    pyan3
    rich
  ];

  pythonImportsCheck = [ "fio_plot" ];

  meta = {
    description = "Create charts from FIO storage benchmark tool output";
    homepage = "https://github.com/louwrentius/fio-plot";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ johnrichardrinehart ];
  };
}
