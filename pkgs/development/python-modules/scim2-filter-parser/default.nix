{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  django,
  sly,
  mock,
  pytestCheckHook,
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

  patches = [
    # https://github.com/15five/scim2-filter-parser/pull/43
    (fetchpatch {
      name = "replace-poetry-with-poetry-core.patch";
      url = "https://github.com/15five/scim2-filter-parser/commit/675d85f3a3ff338e96a408827d64d9e893fa5255.patch";
      hash = "sha256-PjJH1S5CDe/BMI0+mB34KdpNNcHfexBFYBmHolsWH4o=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  propagatedBuildInputs = [ sly ];

  optional-dependencies = {
    django-query = [ django ];
  };

  pythonImportsCheck = [ "scim2_filter_parser" ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ optional-dependencies.django-query;

  meta = with lib; {
    description = "Customizable parser/transpiler for SCIM2.0 filters";
    homepage = "https://github.com/15five/scim2-filter-parser";
    changelog = "https://github.com/15five/scim2-filter-parser/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ s1341 ];
  };
}
