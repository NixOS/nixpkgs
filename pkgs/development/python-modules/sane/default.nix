{
  lib,
  buildPythonPackage,
  fetchPypi,
  sane-backends,
}:

buildPythonPackage rec {
  pname = "sane";
  version = "2.9.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "python-sane";
    sha256 = "JAmOuDxujhsBEm5q16WwR5wHsBPF0iBQm1VYkv5JJd4=";
  };

  buildInputs = [ sane-backends ];

  meta = {
    homepage = "https://github.com/python-pillow/Sane";
    description = "Python interface to the SANE scanner and frame grabber";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
