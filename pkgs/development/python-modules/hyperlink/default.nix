{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy27,
  idna,
  typing ? null,
}:

buildPythonPackage rec {
  pname = "hyperlink";
  version = "21.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Qnr5V9qli8kJRxxsQPdMVFD6Ej3Qk/xT79LpHScFpWs=";
  };

  propagatedBuildInputs = [ idna ] ++ lib.optionals isPy27 [ typing ];

  meta = with lib; {
    description = "Featureful, correct URL for Python";
    homepage = "https://github.com/python-hyper/hyperlink";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ apeschar ];
  };
}
