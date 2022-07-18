{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "pyinstrument";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "joerick";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4gM60UhzN+VnNMTHw6NSU7/LUPHaMgg105D+dO6SDfg=";
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
