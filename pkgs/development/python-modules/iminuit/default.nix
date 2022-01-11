{ lib, buildPythonPackage, isPy3k, fetchPypi, cmake, numpy, pytestCheckHook }:

buildPythonPackage rec {
  pname = "iminuit";
  version = "2.8.4";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b09189f3094896cfc68596adc95b7f1d92772e1de1424e5dc4dd81def56e8b0";
  };

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ numpy ];

  dontUseCmakeConfigure = true;

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/iminuit";
    description = "Python interface for the Minuit2 C++ library";
    license = with licenses; [ mit lgpl2Only ];
    maintainers = with maintainers; [ veprbl ];
  };
}
