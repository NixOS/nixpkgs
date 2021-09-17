{ lib, buildPythonPackage, isPy3k, fetchPypi, cmake, numpy, pytestCheckHook }:

buildPythonPackage rec {
  pname = "iminuit";
  version = "2.8.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ffba627a638fe233bbef03e91af6063c1e5d62405327219b03f0abf50196a95b";
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
