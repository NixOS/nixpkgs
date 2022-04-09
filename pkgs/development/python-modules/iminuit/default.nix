{ lib, buildPythonPackage, isPy3k, fetchPypi, cmake, numpy, pytestCheckHook }:

buildPythonPackage rec {
  pname = "iminuit";
  version = "2.11.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jK55F8otIsaR4AeSv7u4ErhKxcdRIOsq6Hn7StpB7mw=";
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
