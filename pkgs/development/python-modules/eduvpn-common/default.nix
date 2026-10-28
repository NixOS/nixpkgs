{
  buildPythonPackage,
  libeduvpn-common,
  setuptools,
}:

buildPythonPackage rec {
  inherit (libeduvpn-common) version src;
  pname = "eduvpn-common";
  pyproject = true;

  sourceRoot = "${src.name}/wrappers/python";

  patches = [ ./use-nix-lib.patch ];

  postPatch = ''
    substituteInPlace eduvpn_common/loader.py \
                      --subst-var-by libeduvpn-common ${libeduvpn-common.out}/lib/lib${pname}-${version}.so
  '';

  build-system = [ setuptools ];

  dependencies = [ libeduvpn-common ];

  pythonImportsCheck = [ "eduvpn_common" ];

  meta = libeduvpn-common.meta // {
    description = "Python wrapper for libeduvpn-common";
  };
}
