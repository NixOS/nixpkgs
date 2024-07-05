{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
  click,
  numpy,
  scipy,
  rtree,
}:

buildPythonPackage rec {
  pname = "gerbonara";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "gerbonara";
    rev = "v${version}";
    hash = "sha256-VU4Of90YUPoLuiUpIDwSUfxQOoKChNbZE0klHkHEmaY=";
  };

  format = "setuptools";

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    click
    numpy
    scipy
    rtree
  ];

  preConfigure = ''
    # setup.py tries to execute a call to git in a subprocess, this avoids it.
    substituteInPlace setup.py \
      --replace "version=version()," \
                "version='${version}',"
  '';

  pythonImportsCheck = [ "gerbonara" ];

  # Test environment is exceptionally tricky to get set up, so skip for now.
  doCheck = false;

  meta = with lib; {
    description = "Pythonic library for reading/modifying/writing Gerber/Excellon/IPC-356 files";
    mainProgram = "gerbonara";
    homepage = "https://github.com/jaseg/gerbonara";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ wulfsta ];
  };
}
