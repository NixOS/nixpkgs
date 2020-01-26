{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "pynrrd";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "mhe";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wn3ara3i19fi1y9a5j4imyczpa6dkkzd5djggxg4kkl1ff9awrj";
  };

  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    homepage = https://github.com/mhe/pynrrd;
    description = "Simple pure-Python reader for NRRD files";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
