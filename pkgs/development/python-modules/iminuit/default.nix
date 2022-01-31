{ lib, buildPythonPackage, isPy3k, fetchPypi, cmake, numpy, pytestCheckHook }:

buildPythonPackage rec {
  pname = "iminuit";
  version = "2.9.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "656410ceffead79a52d3d727fdcd2bac78d7774239bef0efc3b7a86bae000ff3";
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
