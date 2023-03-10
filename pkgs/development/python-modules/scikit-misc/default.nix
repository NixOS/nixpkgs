{ lib
, fetchPypi
, buildPythonPackage
, cython
, gfortran
, pytestCheckHook
, numpy }:

buildPythonPackage rec {
  pname = "scikit-misc";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-93RqA0eBEGPh7PkSHflINXhQA5U8OLW6hPY/xQjCKRE=";
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace "--cov --cov-report=xml" ""
  '';

  nativeBuildInputs = [
    gfortran
  ];

  buildInputs = [
    cython
    numpy
  ];

  # Tests fail because of infinite recursion error
  doCheck = false;

  pythonImportsCheck = [
    "skmisc"
  ];

  meta = with lib; {
    description = "Miscellaneous tools for scientific computing";
    homepage = "https://github.com/has2k1/scikit-misc";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
