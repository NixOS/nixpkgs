{
  lib,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
  python,
  fetchPypi,
  absl-py,
  etils,
  importlib-resources,
  typing-extensions,
  zipp,
}:

buildPythonPackage rec {
  pname = "array-record";
  version = "0.5.0";
  format = "wheel";

  # As of 2023-10-31, PyPI includes wheels for Python 3.9, 3.10, and 3.11.
  disabled = pythonOlder "3.9" || pythonAtLeast "3.12";

  src =
    let
      pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
    in
    fetchPypi {
      inherit version format;
      pname = "array_record";
      dist = pyShortVersion;
      python = pyShortVersion;
      abi = pyShortVersion;
      platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
      hash =
        {
          cp39 = "sha256-BzMOVue7E1S1+5+XTcPELko81ujc9MbmqLhNsU7pqO0=";
          cp310 = "sha256-eUD9pQu9GsbV8MPD1MiF3Ihr+zYioSOo6P15hYIwPYo=";
          cp311 = "sha256-rAmkI3EIZPYiXrxFowfDC0Gf3kRw0uX0i6Kx6Zu+hNM=";
        }
        .${pyShortVersion} or (throw "${pname} is missing hash for ${pyShortVersion}");
    };

  propagatedBuildInputs = [
    absl-py
    etils
    importlib-resources
    typing-extensions
    zipp
  ];

  pythonImportsCheck = [ "array_record" ];

  meta = with lib; {
    description = "ArrayRecord is a new file format derived from Riegeli, achieving a new frontier of IO efficiency";
    homepage = "https://github.com/google/array_record";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
    platforms = [ "x86_64-linux" ];
  };
}
