{ lib, buildPythonPackage, fetchFromGitHub
, nose
, numpy
, pytest
, python
}:

buildPythonPackage rec {
  pname = "Bottleneck";
  version = "1.3.2";

  src = fetchFromGitHub {
     owner = "pydata";
     repo = "bottleneck";
     rev = "v1.3.2";
     sha256 = "0avm1j9x4d2xl1kyncmn199fnf3cxbiwldmdqll72xzjwm7p7r1b";
  };

  propagatedBuildInputs = [ numpy ];

  postPatch = ''
    substituteInPlace setup.py --replace "__builtins__.__NUMPY_SETUP__ = False" ""
  '';

  checkInputs = [ pytest nose ];
  checkPhase = ''
    py.test -p no:warnings $out/${python.sitePackages}
  '';

  meta = with lib; {
    description = "Fast NumPy array functions written in C";
    homepage = "https://github.com/pydata/bottleneck";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
