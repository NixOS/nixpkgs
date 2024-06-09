{
  lib,
  buildPythonPackage,
  callPackage,
  libeduvpn-common,
  selenium,
  setuptools,
}:

buildPythonPackage rec {
  inherit (libeduvpn-common) version src;
  pname = "eduvpn-common";

  sourceRoot = "${pname}-${version}/wrappers/python";

  patches = [ ./use-nix-lib.patch ];

  postPatch = ''
    substituteInPlace eduvpn_common/loader.py \
                      --subst-var-by libeduvpn-common ${libeduvpn-common.out}/lib/lib${pname}-${version}.so
  '';

  format = "pyproject";

  propagatedBuildInputs = [
    libeduvpn-common
    setuptools
  ];

  nativeCheckInputs = [ selenium ];

  pythonImportsCheck = [ "eduvpn_common" ];

  meta = libeduvpn-common.meta // {
    description = "Python wrapper for libeduvpn-common";
  };
}
