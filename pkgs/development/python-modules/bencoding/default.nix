{
  buildPythonPackage,
  fetchPypi,
  lib,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "bencoding";
  version = "0.2.6";
  format = "wheel";

  src = fetchPypi rec {
    inherit pname version format;
    dist = python;
    python = "py3";
    sha256 = "sha256-7Kt39jmkuxln1fLDAs8EjqjoTZzk8zAGcYb5zBUYj/E=";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Bencoding is a Bcode library for Python3.";
    homepage = "https://github.com/dust8/bencoding";
    license = with lib; [
      licenses.mit
    ];
    maintainers = [
      lib.maintainers.JollyDevelopment
    ];
  };
}
