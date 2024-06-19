{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  traitlets,
  pytestCheckHook,
}:

let
  pname = "comm";
  version = "0.2.2";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ipython";
    repo = "comm";
    rev = "refs/tags/v${version}";
    hash = "sha256-51HSSULhbKb1NdLJ//b3Vh6sOLWp0B4KW469htpduqM=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [ traitlets ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Jupyter Python Comm implementation, for usage in ipykernel, xeus-python etc";
    homepage = "https://github.com/ipython/comm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
