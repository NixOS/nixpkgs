{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  cups,
  libiconv,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycups";
  version = "2.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-hD44XB2/aUmWyoTvAqfzDCg3YDVYj1++rNa64AXPfI0=";
  };

  build-system = [ setuptools ];

  buildInputs = [ cups ] ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  # Wants to connect to CUPS
  doCheck = false;

  meta = {
    description = "Python bindings for libcups";
    homepage = "http://cyberelk.net/tim/software/pycups/";
    license = with lib.licenses; [ gpl2Plus ];
  };
})
