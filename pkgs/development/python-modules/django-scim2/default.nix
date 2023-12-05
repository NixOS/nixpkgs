{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, poetry-core

# propagates
, django
, scim2-filter-parser

# tests
, mock
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-scim2";
  version = "0.19.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "15five";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-larDh4f9/xVr11/n/WfkJ2Tx45DMQqyK3ZzkWAvzeig=";
  };

  # remove this when upstream releases a new version > 0.19.0
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry>=0.12" "poetry-core>=1.5.2" \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    django
    scim2-filter-parser
  ];

  pythonImportsCheck = [
    "django_scim"
  ];

  nativeCheckInputs = [
    mock
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/15five/django-scim2/blob/${src.rev}/CHANGES.txt";
    description = "A SCIM 2.0 Service Provider Implementation (for Django)";
    homepage = "https://github.com/15five/django-scim2";
    license = licenses.mit;
    maintainers = with maintainers; [ s1341 ];
  };
}
