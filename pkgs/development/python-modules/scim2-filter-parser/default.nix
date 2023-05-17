{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, django
, sly
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scim2-filter-parser";
  version = "0.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "15five";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-QEPTYpWlRPWO6Evyt4zoqUST4ousF67GmiOpD7WUqcI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  propagatedBuildInputs = [
    sly
  ];

  passthru.optional-dependencies = {
    django-query = [
      django
    ];
  };

  pythonImportsCheck = [
    "scim2_filter_parser"
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ passthru.optional-dependencies.django-query;

  meta = with lib; {
    description = "A customizable parser/transpiler for SCIM2.0 filters";
    homepage = "https://github.com/15five/scim2-filter-parser";
    changelog = "https://github.com/15five/scim2-filter-parser/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ s1341 ];
  };
}
