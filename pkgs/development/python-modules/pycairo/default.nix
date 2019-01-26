{ lib, fetchFromGitHub, python, buildPythonPackage, pytest, pkgconfig, cairo, xlibsWrapper, isPyPy }:

buildPythonPackage rec {
  pname = "pycairo";
  version = "1.16.3";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pycairo";
    rev = "v${version}";
    sha256 = "0clk6wrfls3fa1xrn844762qfaw6gs4ivwkrfysidbzmlbxhpngl";
  };

  # We need to create the pkgconfig file but it cannot be installed as a wheel since wheels
  # are supposed to be relocatable and do not support --prefix option
  buildPhase = ''
    ${python.interpreter} setup.py build
  '';

  installPhase = ''
    ${python.interpreter} setup.py install --skip-build --prefix="$out" --optimize=1
  '';

  checkPhase = ''
    ${python.interpreter} setup.py test
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python cairo xlibsWrapper ];
  checkInputs = [ pytest ];

  meta.platforms = lib.platforms.linux ++ lib.platforms.darwin;
}
