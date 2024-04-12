{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, brainflow
, cmake
, nix-update-script
, nptyping
, numpy
, setuptools
, typish
, pythonOlder
}:
buildPythonPackage rec {
  pname = "brainflow";
  version = brainflow.version;

  disabled = pythonOlder "3.7";

  src = brainflow.src + "/python_package";

  propagatedBuildInputs = [
    numpy
    (nptyping.overrideAttrs (oldAttrs: rec {
      version = "1.4.4";
      src = fetchFromGitHub {
        owner = "ramonhagenaars";
        repo = "nptyping";
        rev = "refs/tags/v${version}";
        hash = "sha256-c9Qoufn9m3H03Pc8XhGzTBeixnl/elkalv50OrW4gJY=";
      };

      propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [
        typish
      ];

      disabledTestPaths = [
        "tests/test_functions/test_get_type.py"
        "tests/test_functions/test_py_type.py"
      ];
    }))
    setuptools
  ];

  buildInputs = [
    brainflow
  ];

  postInstall = ''
    # Copy over the brainflow shared libraries to the python package
    mkdir -p "$out/lib/$(ls $out/lib)/site-packages/${pname}/lib/"
    cp -Tr "${brainflow}/lib" "$out/lib/$(ls $out/lib)/site-packages/${pname}/lib/"
    ls -la $out/lib/$(ls $out/lib)/site-packages/${pname}/lib/
  '';

  pythonImportsCheck = [
    "brainflow"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "BrainFlow is a library intended to obtain, parse and analyze EEG, EMG, ECG and other kinds of data from biosensors.";
    homepage = "https://brainflow.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ pandapip1 ];
  };
}
