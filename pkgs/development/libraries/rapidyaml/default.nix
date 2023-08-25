{ lib
, stdenv
, cmake
, fetchFromGitHub
, git
}:

stdenv.mkDerivation rec {
  pname = "rapidyaml";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "biojppm";
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-1/P6Szgng94UU8cPFAtOKMS+EmiwfW/IJl2UTolDU5s=";
  };

  nativeBuildInputs = [ cmake git ];

  meta = with lib; {
    description = "A library to parse and emit YAML, and do it fast.";
    homepage = "https://github.com/biojppm/rapidyaml";
    license = licenses.mit;
    maintainers = with maintainers; [ martfont ];
  };
}
