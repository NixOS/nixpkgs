{ stdenv, buildPythonPackage, fetchPypi
, pytest, vega, pandas, ipython, traitlets }:

buildPythonPackage rec {
  pname = "altair";
  version = "1.2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05c47dm20p7m0017p2h38il721rxag1q0457dj7whp0k8rc7qd1n";
  };

  buildInputs = [ pytest ];

  checkPhase = ''
    export LANG=en_US.UTF-8
    py.test altair --doctest-modules
  '';

  propagatedBuildInputs = [ vega pandas ipython traitlets ];

  meta = with stdenv.lib; {
    description = "A declarative statistical visualization library for Python.";
    homepage = https://github.com/altair-viz/altair;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
    platforms = platforms.linux;
  };
}
