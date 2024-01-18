{ lib, fetchPypi, buildPythonPackage, fetchpatch
, libraw
, pytest, mock }:

buildPythonPackage rec {
  pname = "rawkit";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vrhrpr70i61y5q5ysk341x1539ff1q1k82g59zq69lv16s0f76s";
  };

  patches = [
    # Python 3.7 compatibility
    (fetchpatch {
      url = "https://github.com/photoshell/rawkit/commit/663e90afa835d398aedd782c87b8cd0bff64bc9f.patch";
      sha256 = "1cdw0x9bgk0b5jnpjnmd8jpbaryarr3cjqizq44366qh3l0jycxy";
    })
  ];

  buildInputs = [ libraw ];

  nativeCheckInputs = [ pytest mock ];

  checkPhase = ''
    py.test tests
  '';

  meta = with lib; {
    description = "CTypes based LibRaw bindings for Python";
    homepage = "https://rawkit.readthedocs.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
