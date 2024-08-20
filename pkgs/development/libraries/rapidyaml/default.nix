{ lib
, stdenv
, cmake
, fetchFromGitHub
, git
}:

stdenv.mkDerivation rec {
  pname = "rapidyaml";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "biojppm";
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    hash = "sha256-NUPx/1DkhSeCTt3Y5WpsN3wX7pMNOeku7eHdmFv/OWw=";
  };

  nativeBuildInputs = [ cmake git ];

  meta = with lib; {
    description = "Library to parse and emit YAML, and do it fast";
    homepage = "https://github.com/biojppm/rapidyaml";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
