{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  fetchpatch,
  flit-core,
  psycopg2,
  pydantic,
  pytest-asyncio,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-ninja";
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vitalik";
    repo = "django-ninja";
    tag = "v${version}";
    hash = "sha256-nnGIhNGnK7q0nbw7EYJP+xCeS1uiuTrhQxf49dA+Sc8=";
  };

  patches = [
    (fetchpatch {
      name = "django-6.1-support.patch";
      url = "https://github.com/vitalik/django-ninja/commit/18923770f6574ab38a45d0ed2d3d7c240984cdf9.patch";
      hash = "sha256-NcKkgBfXYYQ14/lK5WK4w0ClqrPT1gqTdlPz2e4Ufcs=";
    })
  ];

  build-system = [ flit-core ];

  dependencies = [
    django
    pydantic
  ];

  nativeCheckInputs = [
    psycopg2
    pytest-asyncio
    pytest-django
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/vitalik/django-ninja/releases/tag/${src.tag}";
    description = "Web framework for building APIs with Django and Python type hints";
    homepage = "https://django-ninja.dev";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
