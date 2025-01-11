{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nanomsg,
  setuptools,
  pythonOlder,
}:

buildPythonPackage {
  pname = "nanomsg-python";
  version = "1.0.20190114";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tonysimpson";
    repo = "nanomsg-python";
    rev = "3acd9160f90f91034d4a43ce603aaa19fbaf1f2e";
    hash = "sha256-NHurZWiW/Csp6NyuSV+oD16+L2uPUZWGzb2nWi9b/uE=";
  };

  build-system = [ setuptools ];

  buildInputs = [ nanomsg ];

  # Tests requires network connections
  doCheck = false;

  pythonImportsCheck = [ "nanomsg" ];

  meta = with lib; {
    description = "Bindings for nanomsg";
    homepage = "https://github.com/tonysimpson/nanomsg-python";
    license = licenses.mit;
    maintainers = with maintainers; [ bgamari ];
  };
}
