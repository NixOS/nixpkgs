{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pyinstrument";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "joerick";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0GbJkYBgSOIZrHSKM93SW93jXD+ieYN6A01kWoFbyvQ=";
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
