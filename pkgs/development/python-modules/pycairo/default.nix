{ lib, fetchFromGitHub, meson, ninja, buildPythonPackage, pytest, pkgconfig, cairo, xlibsWrapper, isPy33, isPy3k }:

buildPythonPackage rec {
  pname = "pycairo";
  version = "1.18.0";

  format = "other";

  disabled = isPy33;

  src = fetchFromGitHub {
    owner = "pygobject";
    repo = "pycairo";
    rev = "v${version}";
    sha256 = "0k266cf477j74v7mv0d4jxaq3wx8b7qa85qgh68cn094gzaasqd9";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
  ];

  buildInputs = [
    cairo
    xlibsWrapper
  ];

  checkInputs = [ pytest ];

  mesonFlags = [ "-Dpython=${if isPy3k then "python3" else "python"}" ];

  meta = with lib; {
    description = "Python 2/3 bindings for cairo";
    homepage = https://pycairo.readthedocs.io/;
    license = with licenses; [ lgpl2 mpl11 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
