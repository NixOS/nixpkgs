{ lib, buildPythonPackage, isPyPy, fetchPypi, libffi, pycparser, pytest }:

if isPyPy then null else buildPythonPackage rec {
  pname = "cffi";
  version = "1.10.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mffyilq4qycm8gs4wkgb18rnqil8a9blqq77chdlshzxc8jkc5k";
  };

  propagatedBuildInputs = [ libffi pycparser ];
  buildInputs = [ pytest ];

  patchPhase = ''
    substituteInPlace testing/cffi0/test_ownlib.py --replace "gcc" "cc"
  '';

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    maintainers = with maintainers; [ domenkozar ];
    homepage = https://cffi.readthedocs.org/;
    license = with licenses; [ mit ];
    description = "Foreign Function Interface for Python calling C code";
  };
}
