{ lib
, buildPythonPackage
, fetchPypi
, gsl
, swig
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pygsl";
  version = "2.3.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F3m85Bs8sONw0Rv0EAOFK6R1DFHfW4dxuzQmXo4PHfM=";
  };

  nativeBuildInputs = [
    gsl.dev
    swig
  ];
  buildInputs = [
    gsl
  ];
  propagatedBuildInputs = [
    numpy
  ];

  preCheck = ''
    cd tests
  '';
  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python interface for GNU Scientific Library";
    homepage = "https://github.com/pygsl/pygsl";
    changelog = "https://github.com/pygsl/pygsl/blob/v${version}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ amesgen ];
  };
}
