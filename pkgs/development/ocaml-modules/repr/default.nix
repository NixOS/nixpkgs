{ lib, buildDunePackage, fetchFromGitHub, base64, either, fmt, jsonm, uutf, optint }:

buildDunePackage rec {
  pname = "repr";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = "repr";
    rev = version;
    sha256 = "sha256-jF8KmaG07CT26O/1ANc6s1yHFJqhXDtd0jgTA04tIgw=";
  };

  minimalOCamlVersion = "4.08";
  strictDeps = true;

  propagatedBuildInputs = [
    base64
    either
    fmt
    jsonm
    uutf
    optint
  ];

  meta = with lib; {
    description = "Dynamic type representations. Provides no stability guarantee";
    homepage = "https://github.com/mirage/repr";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
