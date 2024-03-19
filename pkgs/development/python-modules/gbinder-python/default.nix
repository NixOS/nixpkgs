{ lib
, fetchFromGitHub
, buildPythonPackage
, cython
, pkg-config
, libgbinder
}:

buildPythonPackage rec {
  pname = "gbinder-python";
  version = "1.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "erfanoabdi";
    repo = pname;
    rev = version;
    sha256 = "1X9gAux9w/mCEVmE3Yqvvq3kU7hu4iAFaZWNZZZxt3E=";
  };

  buildInputs = [
    libgbinder
  ];

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  postPatch = ''
    # Fix pkg-config name for cross-compilation
    substituteInPlace setup.py --replace "pkg-config" "$PKG_CONFIG"
  '';

  setupPyGlobalFlags = [ "--cython" ];

  meta = {
    description = "Python bindings for libgbinder";
    homepage = "https://github.com/erfanoabdi/gbinder-python";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mcaju ];
  };
}
