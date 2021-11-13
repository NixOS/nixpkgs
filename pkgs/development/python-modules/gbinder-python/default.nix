{ stdenv
, lib
, fetchFromGitHub
, buildPythonPackage
, cython
, pkg-config
, libgbinder
}:

buildPythonPackage rec {
  pname = "gbinder-python";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "erfanoabdi";
    repo = pname;
    rev = version;
    sha256 = "0jgblzakjgsy0cj93bmh5gr7qnl2xgsrm0wzc6xjvzry9lrbs360";
  };

  buildInputs = [
    libgbinder
  ];

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  setupPyGlobalFlags = [ "--cython" ];

  meta = with lib; {
    description = "Python bindings for libgbinder";
    homepage = "https://github.com/erfanoabdi/gbinder-python";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mcaju ];
    platforms = platforms.linux;
  };
}
