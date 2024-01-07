{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pymupdf
, numpy
, ipython
, texlive
}:

buildPythonPackage rec {
  pname = "pytikz-allefeld"; # "pytikz" on pypi is a different module
  version = "unstable-2022-11-01";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "allefeld";
    repo = "pytikz";
    rev = "f878ebd6ce5a647b1076228b48181b147a61abc1";
    hash = "sha256-G59UUkpjttJKNBN0MB/A9CftO8tO3nv8qlTxt3/fKHk=";
  };

  propagatedBuildInputs = [
    pymupdf
    numpy
    ipython
  ];

  pythonImportsCheck = [ "tikz" ];

  nativeCheckInputs = [ texlive.combined.scheme-small ];
  checkPhase = ''
    runHook preCheck
    python -c 'if 1:
      from tikz import *
      pic = Picture()
      pic.draw(line([(0, 0), (1, 1)]))
      print(pic.code())
      pic.write_image("test.pdf")
    '
    test -s test.pdf
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/allefeld/pytikz";
    description = "A Python interface to TikZ";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pbsds ];
    broken = stdenv.isDarwin;
  };
}
