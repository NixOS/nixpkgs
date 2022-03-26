{ buildPythonPackage, lib, fetchFromGitHub, gfortran
, makeWrapper, numpy, pytest, mock, pytest-mock
} :

buildPythonPackage rec {
  pname = "i-pi";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "i-pi";
    repo = "i-pi";
    rev = "v${version}";
    sha256 = "0d0ag57aa0fsqjwya27fyj8alimjvlxzgh6hxjqy1k4ap9h3n1cy";
  };

  nativeBuildInputs = [
    gfortran
    makeWrapper
  ];

  propagatedBuildInputs = [ numpy ];

  checkInputs = [
    pytest
    mock
    pytest-mock
  ];

  postFixup = ''
    wrapProgram $out/bin/i-pi \
      --set IPI_ROOT $out
  '';

  meta = with lib; {
    description = "A universal force engine for ab initio and force field driven (path integral) molecular dynamics";
    license = with licenses; [ gpl3Only mit ];
    homepage = "http://ipi-code.org/";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
