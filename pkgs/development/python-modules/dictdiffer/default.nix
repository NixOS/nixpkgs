{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dictdiffer";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "inveniosoftware";
    repo = "dictdiffer";
    rev = "v${version}";
    hash = "sha256-lQyPs3lQWtsvNPuvvwJUTDzrFaOX5uwGuRHe3yWUheU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner>=2.7'," ""
    substituteInPlace pytest.ini \
      --replace ' --isort --pydocstyle --pycodestyle --doctest-glob="*.rst" --doctest-modules --cov=dictdiffer --cov-report=term-missing' ""
  '';

  pythonImportsCheck = [ "dictdiffer" ];

  meta = with lib; {
    description = "Module to diff and patch dictionaries";
    homepage = "https://github.com/inveniosoftware/dictdiffer";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
