{ buildPythonPackage, lib, fetchFromGitHub, gfortran
, makeWrapper, numpy, pytest, mock, pytest-mock
} :

buildPythonPackage rec {
  pname = "i-pi";
  version = "2.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "i-pi";
    repo = "i-pi";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-c1bs8ZI/dfDwKx5Df8ndtsDxESQrdbMkvrjfI6b9JTg=";
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
    description = "A universal force engine for ab initio and force field driven (path integral) molecular dynamics";
    license = with licenses; [ gpl3Only mit ];
    homepage = "http://ipi-code.org/";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
