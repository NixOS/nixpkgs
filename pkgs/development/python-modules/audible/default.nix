{ lib, fetchFromGitHub, buildPythonPackage, beautifulsoup4, httpx, pbkdf2, pillow, pyaes, rsa }:

buildPythonPackage rec {
  pname = "audible";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "mkb79";
    repo = "Audible";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-SIEDBuMCC/Hap2mGVbKEFic96ClN369SEsV06Sg+poY=";
  };

  propagatedBuildInputs = [ beautifulsoup4 httpx pbkdf2 pillow pyaes rsa ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'httpx>=0.20.*,<=0.22.*' 'httpx'
  '';

  pythonImportsCheck = [ "audible"];

  meta = with lib; {
    description = "A(Sync) Interface for internal Audible API written in pure Python";
    license = licenses.agpl3;
    homepage = "https://github.com/mkb79/Audible";
    maintainers = with maintainers; [ jvanbruegge ];
  };
}
