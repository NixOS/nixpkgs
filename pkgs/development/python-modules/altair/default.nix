{ stdenv, buildPythonPackage, fetchPypi
, pytest, vega, pandas, ipython, traitlets }:

buildPythonPackage rec {
  pname = "altair";
  version = "1.2.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c1303f77f1ba4d632f2958c83c0f457b2b969860b1ac9adfb872aefa1780baa7";
  };

  buildInputs = [ pytest ];

  checkPhase = ''
    export LANG=en_US.UTF-8
    py.test altair --doctest-modules
  '';

  propagatedBuildInputs = [ vega pandas ipython traitlets ];
  # Disabling checks, MockRequest object has no method send()
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A declarative statistical visualization library for Python.";
    homepage = https://github.com/altair-viz/altair;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
    platforms = platforms.linux;
  };
}
