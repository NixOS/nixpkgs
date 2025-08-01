{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pandas,
  setuptools,
  simplesqlite,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "df-diskcache";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "df-diskcache";
    rev = "v${version}";
    hash = "sha256-s+sqEPXw6tbEz9mnG+qeUSF6BmDssYhaDYOmraFaRbw=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pandas
    simplesqlite
    typing-extensions
  ];

  preCheck = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "dfdiskcache" ];

  meta = with lib; {
    description = "Python library for caching pandas.DataFrame objects to local disk";
    homepage = "https://github.com/thombashi/df-diskcache";
    license = licenses.mit;
    maintainers = with maintainers; [ henrirosten ];
  };
}
