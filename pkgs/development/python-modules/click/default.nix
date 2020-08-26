{ lib, buildPythonPackage, fetchPypi, locale, pytestCheckHook }:

buildPythonPackage rec {
  pname = "click";
  version = "7.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a";
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
