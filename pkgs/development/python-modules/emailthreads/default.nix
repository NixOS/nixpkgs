{ lib, fetchFromGitHub, buildPythonPackage
, python, isPy3k }:

buildPythonPackage rec {
  pname = "emailthreads";
  version = "0.1.0";
  disabled = !isPy3k;

  # pypi is missing files for tests
  src = fetchFromGitHub {
    owner = "emersion";
    repo = "python-emailthreads";
    rev = "v${version}";
    sha256 = "17pfal8kbxhs025apkijqbkppw2lljca8x1cwcx49jv60h05c3cn";
  };

  PKGVER = version;

  checkPhase = ''
    ${python.interpreter} -m unittest discover test
  '';

  meta = with lib; {
    homepage = https://github.com/emersion/python-emailthreads;
    description = "Python library to parse and format email threads";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
