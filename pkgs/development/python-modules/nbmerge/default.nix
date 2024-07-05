{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  nbformat,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "nbmerge";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jbn";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Uqs/SO/AculHCFYcbjW08kLQX5GSU/eAwkN2iy/vhLM=";
  };

  patches = [ ./pytest-compatibility.patch ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ nbformat ];

  nativeCheckInputs = [ pytestCheckHook ];

  postCheck = ''
    patchShebangs .
    PATH=$PATH:$out/bin ./cli_tests.sh
  '';

  pythonImportsCheck = [ "nbmerge" ];

  meta = {
    description = "Tool to merge/concatenate Jupyter (IPython) notebooks";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "nbmerge";
  };
}
