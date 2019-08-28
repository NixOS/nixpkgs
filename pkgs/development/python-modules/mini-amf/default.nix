{ lib, buildPythonPackage, fetchFromGitHub
, six
, defusedxml
}:

buildPythonPackage rec {
  pname = "mini-amf";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "zackw";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jirg4wnwx8yr65adhbiig0laspiqvplqd180dgpnabj89c72p0m";
  };

  propagatedBuildInputs = [ defusedxml six ];

  meta = with lib; {
    description = "Minimal AMF encoder and decoder for Python";
    homepage = "https://github.com/zackw/mini-amf";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
