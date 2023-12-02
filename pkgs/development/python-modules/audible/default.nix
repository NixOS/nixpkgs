{ lib
, fetchFromGitHub
, buildPythonPackage

# build-system
, setuptools

# dependencies
, beautifulsoup4
, httpx
, pbkdf2
, pillow
, pyaes
, rsa
}:

buildPythonPackage rec {
  pname = "audible";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkb79";
    repo = "Audible";
    rev = "refs/tags/v${version}";
    hash = "sha256-qLU8FjJBPKFgjpumPqRiiMBwZi+zW46iEmWM8UerMgs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    httpx
    pbkdf2
    pillow
    pyaes
    rsa
  ];

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
