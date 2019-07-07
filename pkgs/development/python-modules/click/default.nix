{ lib, buildPythonPackage, fetchPypi, locale, pytest }:

buildPythonPackage rec {
  pname = "click";
  version = "7.0";

  src = fetchPypi {
    pname = "Click";
    inherit version;
    sha256 = "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7";
  };

  postPatch = ''
    substituteInPlace click/_unicodefun.py \
      --replace "'locale'" "'${locale}/bin/locale'"
  '';

  buildInputs = [ pytest ];

  checkPhase = ''
    py.test tests
  '';

  # https://github.com/pallets/click/issues/823
  doCheck = false;

  meta = with lib; {
    homepage = http://click.pocoo.org/;
    description = "Create beautiful command line interfaces in Python";
    longDescription = ''
      A Python package for creating beautiful command line interfaces in a
      composable way, with as little code as necessary.
    '';
    license = licenses.bsd3;
  };
}
