{ lib, fetchFromGitHub, buildPythonPackage, beautifulsoup4, httpx, pbkdf2, pillow, pyaes, rsa }:

buildPythonPackage rec {
  pname = "audible";
  version = "0.8.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mkb79";
    repo = "Audible";
    rev = "refs/tags/v${version}";
    hash = "sha256-SIEDBuMCC/Hap2mGVbKEFic96ClN369SEsV06Sg+poY=";
  };

  propagatedBuildInputs = [ beautifulsoup4 httpx pbkdf2 pillow pyaes rsa ];

  postPatch = ''
    sed -i "s/httpx.*/httpx',/" setup.py
  '';

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "audible"];

  meta = with lib; {
    description = "A(Sync) Interface for internal Audible API written in pure Python";
    license = licenses.agpl3;
    homepage = "https://github.com/mkb79/Audible";
    maintainers = with maintainers; [ jvanbruegge ];
  };
}
