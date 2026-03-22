{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
}:

buildPythonPackage rec {
  pname = "filebytes";
  version = "0.10.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h97i6h525hg401dvvaa5krxi184qpvldbdn0izmirvr9pvh4hkn";
  };

  patches = [
    # Upstream PR: https://github.com/sashs/filebytes/pull/36
    (fetchpatch {
      name = "python-3.14.patch";
      url = "https://github.com/sashs/filebytes/commit/469058d50d4b7ff8da54b623a0a1aa972cd78dc6.patch";
      hash = "sha256-VizYOqyJ3xpJIU4KKsYcz2DCurlfrWTgdsn84FVWD6w=";
    })
  ];

  meta = {
    homepage = "https://scoding.de/filebytes-introduction";
    license = lib.licenses.gpl2;
    description = "Scripts to parse ELF, PE, Mach-O and OAT (Android Runtime)";
    maintainers = with lib.maintainers; [ bennofs ];
  };
}
