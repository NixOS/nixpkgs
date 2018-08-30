{ stdenv, fetchPypi, buildPythonPackage
, libraw
, pytest, mock }:

buildPythonPackage rec {
  pname = "rawkit";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vrhrpr70i61y5q5ysk341x1539ff1q1k82g59zq69lv16s0f76s";
  };

  buildInputs = [ libraw ];

  checkInputs = [ pytest mock ];

  checkPhase = ''
    py.test tests
  '';

  meta = with stdenv.lib; {
    description = "CTypes based LibRaw bindings for Python";
    homepage = https://rawkit.readthedocs.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
