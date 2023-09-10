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

  meta = with lib; {
    description = "Python bindings for libgbinder";
    homepage = "https://github.com/erfanoabdi/gbinder-python";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mcaju ];
    platforms = platforms.linux;
  };
}
