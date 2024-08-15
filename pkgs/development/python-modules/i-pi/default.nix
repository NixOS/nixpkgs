{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  gfortran,
  makeWrapper,
  numpy,
  pytest,
  mock,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "i-pi";
  version = "3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "i-pi";
    repo = "i-pi";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-SJ0qTwwdIOR1nXs9MV6O1oxJPR6/6H86wscDy/sLc/g=";
  };

  nativeBuildInputs = [
    gfortran
    makeWrapper
  ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [
    pytest
    mock
    pytest-mock
  ];

  postFixup = ''
    wrapProgram $out/bin/i-pi \
      --set IPI_ROOT $out
  '';

  meta = with lib; {
    description = "Universal force engine for ab initio and force field driven (path integral) molecular dynamics";
    license = with licenses; [
      gpl3Only
      mit
    ];
    homepage = "http://ipi-code.org/";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
