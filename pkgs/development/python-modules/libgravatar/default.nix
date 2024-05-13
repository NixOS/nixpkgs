{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "libgravatar";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "pabluk";
    repo = "libgravatar";
    rev = "refs/tags/${version}";
    hash = "sha256-rJv/jfdT+JldxR0kKtXQLOI5wXQYSQRWJnqwExwWjTA=";
  };

  nativeBuildInputs = with python3Packages; [ setuptools ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "libgravatar" ];

  meta = with lib; {
    homepage = "https://github.com/pabluk/libgravatar";
    description = "A library that provides a Python 3 interface for the Gravatar API";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ gador ];
  };
}
