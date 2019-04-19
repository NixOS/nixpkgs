{ stdenv, buildPythonPackage, python3Packages, fetchPypi, qpdf, pythonOlder }:


buildPythonPackage rec {
  pname = "pikepdf";
  version = "1.2.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rhp66j091px0jvlx817h8csadkmvg26l3y98ccs5cd06xh6ly2p";
  };

  buildInputs = with python3Packages; [ defusedxml lxml qpdf pybind11
                                        setuptools setuptools_scm
                                      ];
  checkInputs = with python3Packages; [ nose pytest hypothesis pillow ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "setuptools_scm_git_archive" ""
  '';

  preConfigure = ''
    mkdir tmp
    export HOME=tmp
  '';

  checkPhase = ''
    ${python3Packages.python.interpreter} -m pytest
  '';

  meta = with stdenv.lib; {
    description = "Read and write PDFs with Python, powered by qpdf";
    homepage = https://github.com/pikepdf/pikepdf;
    license = licenses.mpl20;
    maintainers = with maintainers; [ leenaars ];
  };
}

