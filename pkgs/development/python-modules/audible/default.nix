{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  poetry-core,

  # dependencies
  beautifulsoup4,
  httpx,
  pbkdf2,
  pillow,
  pyaes,
  rsa,

  # test dependencies
  pytestCheckHook,
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

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pillow
    beautifulsoup4
    httpx
    pbkdf2
    pyaes
    rsa
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "audible" ];

  meta = with lib; {
    description = "A(Sync) Interface for internal Audible API written in pure Python";
    license = licenses.agpl3Only;
    homepage = "https://github.com/mkb79/Audible";
    maintainers = with maintainers; [ jvanbruegge ];
  };
}
