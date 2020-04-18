{ stdenv, buildPythonPackage, fetchFromGitHub, isPy3k, pycryptodome, chardet, nose, sortedcontainers, fetchpatch }:

buildPythonPackage rec {
  pname = "pdfminer_six";
  version = "20200402";

  disabled = !isPy3k;

  # No tests in PyPi Tarball
  src = fetchFromGitHub {
    owner = "pdfminer";
    repo = "pdfminer.six";
    rev = version;
    sha256 = "1wl64r3ifpwi7mm5pcxc0ji7w380nxcq3zrv66n95lglm4zqkf26";
  };

  patches = [
    # Add shebang line to scripts. See: https://github.com/pdfminer/pdfminer.six/pull/408
    (fetchpatch {
      url = "https://github.com/pdfminer/pdfminer.six/commit/0c2f44b6de064d9a3cea99bde5b8e9c6a525a69c.patch";
      sha256 = "1vml66grnvg4g26mya24kiyxsz809d4mr7wz8qmawjbn4ss65y21";
      excludes = [ "CHANGELOG.md" ];
    })
  ];

  propagatedBuildInputs = [ chardet pycryptodome sortedcontainers ];

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    description = "PDF parser and analyzer";
    homepage = "https://github.com/pdfminer/pdfminer.six";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy marsam ];
  };
}

