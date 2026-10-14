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

  # Upstream pins pandas<3 (still true as of the v0.1.0 tag), but the
  # package works fine against pandas 3.x; relax the constraint rather
  # than staying behind on pandas.
  # https://github.com/thombashi/df-diskcache/blob/v0.1.0/requirements/requirements.txt
  pythonRelaxDeps = [ "pandas" ];

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

  meta = {
    description = "Python library for caching pandas.DataFrame objects to local disk";
    homepage = "https://github.com/thombashi/df-diskcache";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ henrirosten ];
  };
}
