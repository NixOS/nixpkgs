{ lib, buildPythonPackage, isPy3k, fetchPypi, cmake, numpy, pytestCheckHook }:

buildPythonPackage rec {
  pname = "iminuit";
  version = "2.8.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e22d81a53ce3316f0253bf0b7831bd72ac1122ca78896c2ee2e585178c5c9ae";
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
