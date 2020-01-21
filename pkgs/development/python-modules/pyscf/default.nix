{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, openblas
, libcint
, libxc
, h5py
, numpy
, scipy
, pytest
}:

buildPythonPackage rec {
  pname = "pyscf";
  version = "1.7.0";

  # must download from GitHub to get the Cmake & C source files
  src = fetchFromGitHub {
    owner = "pyscf";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gdmc04nr699bq6gkw9isfzahj0k2gqhxnjg6gj9rybmglarkn15";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libcint
    libxc
    openblas
  ];
  cmakeFlags = [
    # disable rebuilding/downloading the required libraries
    "-DBUILD_LIBCINT=0"
    "-DBUILD_LIBXC=0"
    "-DBUILD_XCFUN=0"
  ];
  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [
    h5py
    numpy
    scipy
  ];

  PYSCF_INC_DIR = lib.strings.makeLibraryPath [ libcint libxc ];

  pythonImportsCheck = [ "pyscf" ];
  checkInputs = [ pytest ];
  checkPhase = ''
    pytest ./pyscf/tools/test
  '';

  meta = with lib; {
    description = "Python-based Simulations of Chemistry Framework";
    longDescription = ''
      PySCF is an open-source collection of electronic structure modules powered by Python.
      The package aims to provide a simple, lightweight, and efficient platform
      for quantum chemistry calculations and methodology development.
    '';
    homepage = "http://www.pyscf.org/";
    downloadPage = "https://github.com/pyscf/pyscf/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
