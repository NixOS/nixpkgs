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
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "15five";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-KmtOtI/5HT0lVwvXQFTlEwMeptoa4cA5hTSgSULxhIc=";
  };

  patches = [
    # https://github.com/15five/scim2-filter-parser/pull/43
    (fetchpatch {
      name = "replace-poetry-with-poetry-core.patch";
      url = "https://github.com/15five/scim2-filter-parser/commit/675d85f3a3ff338e96a408827d64d9e893fa5255.patch";
      hash = "sha256-PjJH1S5CDe/BMI0+mB34KdpNNcHfexBFYBmHolsWH4o=";
    })
  ];

  build-system = [ poetry-core ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  dependencies = [ sly ];

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
