{ lib, buildPythonPackage, fetchPypi, locale, pytestCheckHook }:

buildPythonPackage rec {
  pname = "click";
  version = "7.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k60i2fvxf8rxazlv04mnsmlsjrj5i5sda3x1ifhr0nqi7mb864a";
  };

  postPatch = ''
    substituteInPlace src/click/_unicodefun.py \
      --replace "'locale'" "'${locale}/bin/locale'"
  '';

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://click.palletsprojects.com/";
    description = "Create beautiful command line interfaces in Python";
    longDescription = ''
      A Python package for creating beautiful command line interfaces in a
      composable way, with as little code as necessary.
    '';
    license = licenses.bsd3;
  };
}
