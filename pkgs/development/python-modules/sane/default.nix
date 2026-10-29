{
  lib,
  buildPythonPackage,
  fetchPypi,
  sane-backends,
}:

buildPythonPackage (finalAttrs: {
  pname = "sane";
  version = "2.9.1";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "python-sane";
    hash = "sha256-JAmOuDxujhsBEm5q16WwR5wHsBPF0iBQm1VYkv5JJd4=";
  };

  buildInputs = [ sane-backends ];

  meta = {
    homepage = "https://github.com/python-pillow/Sane";
    description = "Python interface to the SANE scanner and frame grabber";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
