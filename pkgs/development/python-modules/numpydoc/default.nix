{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, jinja2
, sphinx
, pytestCheckHook
, matplotlib
}:

buildPythonPackage rec {
  pname = "numpydoc";
  version = "1.4.0";
  format = "setuptools";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "sha256-lJTa8cdhL1mQX6CeZcm4qQu6yzgE2R96lOd4gx5vz6U=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "Jinja2>=2.10,<3.1" "Jinja2>=2.10,<3.2"
    substituteInPlace setup.cfg \
      --replace "--cov-report=" "" \
      --replace "--cov=numpydoc" ""
  '';

  propagatedBuildInputs = [
    jinja2
    sphinx
  ];

  checkInputs = [
    matplotlib
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/numpy/numpydoc/issues/373
    "test_MyClass"
    "test_my_function"
    "test_reference"
  ];

  pythonImportsCheck = [
    "numpydoc"
  ];

  meta = {
    description = "Sphinx extension to support docstrings in Numpy format";
    homepage = "https://github.com/numpy/numpydoc";
    license = lib.licenses.free;
   };
}
