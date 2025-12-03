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
  pytestCheckHook,
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

  patches = map (patch: fetchpatch2 {
      url = "https://github.com/louwrentius/fio-plot/commit/${patch.rev}.patch?full_index=1";
      inherit (patch) hash;
    })
    [
      {
        rev = "420f46508bf861d5279c9b378ca7b08e39a828f6";
        hash = "sha256-GrKdExbVuvtb+Ru1kGff30WU2RWvSKTu7yl0yk0IZUs=";
      }
      {
        rev = "610fb3b03435fe957f71ddd8f95f51c743e1061d";
        hash = "sha256-n1vvkwuXWxquQL0t7Ppo+jvgchc42IkkW1Z6hWro5hQ=";
      }
      {
        rev = "6683208c94e8087a1629c4a7204f9dec5dea5ca9";
        hash = "sha256-pNABP+m1ID1JbKKKXdQQieXx2FHhF7OeOH1limA895A=";
      }
      {
        rev = "ebfdab83df2b9d435834507106e2151ac99d7ff3";
        hash = "sha256-RXJS1TXHuCU6QuJ4ES4mGdWKwe1NKF9Qr2QQAk/TxbQ=";
      }
      {
        rev = "a53d97d5f094ca6bed841cb7e95563d5ad0e2b53";
        hash = "sha256-VKtglKfOgZ+v3Zj2dcAMpVk/EzyK21W5RmjjKGQgFgo=";
      }
    ];

  dependencies = [
    matplotlib
    numpy
    pillow
    pyan3
    rich
  ];

  nativeBuildInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fio_plot" ];

  meta = {
    description = "Create charts from FIO storage benchmark tool output";
    homepage = "https://github.com/louwrentius/fio-plot";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ johnrichardrinehart ];
  };
}
