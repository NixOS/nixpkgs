{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  brainflow,
  cmake,
  nptyping,
  numpy,
  python,
  setuptools,
  typish,
  pythonOlder,
}:
buildPythonPackage rec {
  inherit (brainflow) pname version src;

  pyproject = true;
  build-system = [ setuptools ];

  disabled = pythonOlder "3.7";

  sourceRoot = "${src.name}/python_package";

  dependencies = [
    numpy
    (nptyping.overrideAttrs (finalAttrs: let
      version = "1.4.4";
    in {
      inherit version;
      src = fetchFromGitHub {
        owner = "ramonhagenaars";
        repo = "nptyping";
        rev = "refs/tags/v${version}";
        hash = "sha256-c9Qoufn9m3H03Pc8XhGzTBeixnl/elkalv50OrW4gJY=";
      };

      propagatedBuildInputs = finalAttrs.propagatedBuildInputs ++ [ typish ];

      disabledTestPaths = [
        "tests/test_functions/test_get_type.py"
        "tests/test_functions/test_py_type.py"
      ];
    }))
  ];

  buildInputs = [ brainflow ];

  postInstall = ''
    mkdir -p "$out/${python.sitePackages}/brainflow/lib/"
    cp -Tr "${brainflow}/lib" "$out/${python.sitePackages}/brainflow/lib/"
  '';

  pythonImportsCheck = [ "brainflow" ];

  meta = {
    description = "BrainFlow is a library intended to obtain, parse and analyze EEG, EMG, ECG and other kinds of data from biosensors.";
    homepage = "https://brainflow.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pandapip1
      ziguana
    ];
  };
}
