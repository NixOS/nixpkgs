{
  lib,
  fetchPypi,
  python3Packages,
  plover,
  setuptools,
  pythonImportsCheckHook,
}:
python3Packages.buildPythonPackage rec {
  pname = "plover-stitching";
  version = "0.1.0";
  pyproject = true;
  build-system = [ setuptools ];

  meta = with lib; {
    description = "Write stitched words like T-H-I-S or define stitched sequences like heh-heh-heh";
    maintainers = with maintainers; [ twey ];
    license = licenses.gpl2Plus;
  };

  src = fetchPypi {
    pname = "plover_stitching";
    inherit version;
    hash = "sha256-08wsVTf89kKattOM0Uj/R/heW9zSX7JQBcza8aJJwxc=";
  };

  # pytestCheckHook disabled because tests rely on an old Plover
  # testing API
  nativeCheckInputs = [
    pythonImportsCheckHook
  ];

  propagatedBuildInputs = [ plover ];
}
