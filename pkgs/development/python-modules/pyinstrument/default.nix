{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pyinstrument";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "joerick";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-HvPapa3b9/Wc4ClaMOmCAIeHS7H4V9aCR9JCDol2ElE=";
  };

  # Module import recursion
  doCheck = false;

  pythonImportsCheck = [
    "pyinstrument"
  ];

  meta = with lib; {
    description = "Call stack profiler for Python";
    homepage = "https://github.com/joerick/pyinstrument";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
