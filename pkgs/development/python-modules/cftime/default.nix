{ lib
, buildPythonPackage
, cython
, fetchPypi
, fetchpatch
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cftime";
  version = "1.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hhTAD7ilBG3jBP3Ybb0iT5lAgYXXskWsZijQJ2WW5tI=";
  };

  patches = [
    (fetchpatch {
      # Fix test_num2date_precision by checking per platform precision
      url = "https://github.com/Unidata/cftime/commit/221ff2195d588a43a7984597033b678f330fbc41.patch";
      hash = "sha256-3XTJuET20g9QElM/8WGnNzJBFZ0oUN4ikhWKppwcyNM=";
    })
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';


  nativeBuildInputs = [
    cython
    numpy
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cftime"
  ];

  meta = with lib; {
    description = "Time-handling functionality from netcdf4-python";
    homepage = "https://github.com/Unidata/cftime";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
