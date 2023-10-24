{ lib
, absl-py
, buildPythonPackage
, etils
, fetchPypi
, importlib-resources
, python
, typing-extensions
, zipp
}:

buildPythonPackage rec {
  pname = "array-record";
  version = "0.4.1";
  format = "wheel";

  disabled = python.pythonVersion != "3.10";

  src = fetchPypi {
    inherit version format;
    pname = "array_record";
    dist = "py310";
    python = "py310";
    hash = "sha256-agyO1v36ryzs09XGucE+EWrTKZZJYRyP0YTWRVf7q6g=";
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
