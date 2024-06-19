{ lib
, stdenv
, cmake
, fetchFromGitHub
, git
}:

stdenv.mkDerivation rec {
  pname = "rapidyaml";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "biojppm";
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-p9XaMsrOgnEdb0yl52HXhNzz6YxuvTD5GCaq1a+l1bQ=";
  };

  nativeBuildInputs = [ cmake git ];

  meta = with lib; {
    description = "A library to parse and emit YAML, and do it fast.";
    homepage = "https://github.com/biojppm/rapidyaml";
    license = licenses.mit;
    maintainers = with maintainers; [ martfont ];
    platforms = platforms.all;
  };
}
