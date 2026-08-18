{
  lib,
  buildPythonPackage,
  fetchPypi,
  jinja2,
  setuptools,
  rope,
}:

buildPythonPackage (finalAttrs: {
  pname = "nixpkgs-pytools";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "11skcbi1lf9qcv9j5ikifb4pakhbbygqpcmv3390j7gxsa85cn19";
  };

  build-system = [ setuptools ];

  dependencies = [
    jinja2
    setuptools
    rope
  ];

  # tests require network ..
  doCheck = false;

  meta = {
    description = "Tools for removing the tedious nature of creating nixpkgs derivations";
    homepage = "https://github.com/nix-community/nixpkgs-pytools";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
