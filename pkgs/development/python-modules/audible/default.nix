{ lib, fetchFromGitHub, buildPythonPackage, beautifulsoup4, httpx, pbkdf2, pillow, pyaes, rsa }:

buildPythonPackage rec {
  pname = "audible";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "mkb79";
    repo = "Audible";
    rev = "v${version}";
    sha256 = "0fsb5av4s7fvpn0iryl8jj3lwffwlxgbwj46l3fidy0l58nq3b1d";
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
