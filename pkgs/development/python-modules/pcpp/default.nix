{ buildPythonPackage
, fetchFromGitHub
, lib
}:

buildPythonPackage rec {
  pname = "pcpp";
  version = "1.30";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ned14";
    repo = "pcpp";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Fs+CMV4eRKcB+KdV93ncgcqaMnO5etnMY/ivmSJh3Wc=";
    fetchSubmodules = true;
  };

  meta = with lib; {
    homepage = "https://github.com/ned14/pcpp";
    description = "A C99 preprocessor written in pure Python";
    license = licenses.bsd0;
    maintainers = with maintainers; [ rakesh4g ];
 };
}
