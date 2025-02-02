{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  unittestCheckHook,
  setuptools,
  django,
}:

buildPythonPackage rec {
  pname = "django-cte";
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dimagi";
    repo = "django-cte";
    rev = "refs/tags/v${version}";
    hash = "sha256-OCENg94xHBeeE4A2838Cu3q2am2im2X4SkFSjc6DuhE=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Require Database connection
    "test_cte_queryset"
    "test_experimental_left_outer_join"
    "test_explain"
    "test_left_outer_join_on_empty_result_set_cte"
    "test_named_ctes"
    "test_named_simple_ctes"
    "test_non_cte_subquery"
    "test_outerref_in_cte_query"
    "test_simple_cte_query"
    "test_update_cte_query"
    "test_update_with_subquery"
    "test_heterogeneous_filter_in_cte"
    "test_raw_cte_sql"
    "test_alias_as_subquery"
    "test_alias_change_in_annotation"
    "test_attname_should_not_mask_col_name"
    "test_pickle_recursive_cte_queryset"
    "test_recursive_cte_query"
    "test_recursive_cte_reference_in_condition"
    "test_union_with_first"
    "test_union_with_select_related_and_first"
    "test_union_with_select_related_and_order"
  ];

  pythonImportsCheck = [ "django_cte" ];

  meta = {
    description = "Common Table Expressions (CTE) for Django";
    homepage = "https://github.com/dimagi/django-cte";
    changelog = "https://github.com/dimagi/django-cte/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
