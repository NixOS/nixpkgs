{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-insightidr";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-insightidr";
    tag = "v${version}";
    hash = "sha256-dc25zDYQeU9W9qwrRz7zsM2wOl8kMapDvwFhB6VOwhY=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  pythonRelaxDeps = [ "pysigma" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "sigma.backends.insight_idr"
    "sigma.pipelines.insight_idr"
  ];

  disabledTests = [
    # Tests are outdated
    "est_insight_idr_pipeline_dns_field_mapping"
    "test_insight_idr_base64_query"
    "test_insight_idr_cidr_query"
    "test_insight_idr_condition_nested_logic"
    "test_insight_idr_contains_all_query"
    "test_insight_idr_contains_any_query"
    "test_insight_idr_endswith_any_query"
    "test_insight_idr_keyword_and_query"
    "test_insight_idr_keyword_or_query"
    "test_insight_idr_leql_advanced_search_output_format"
    "test_insight_idr_leql_detection_definition_output_format"
    "test_insight_idr_multi_selection_same_field"
    "test_insight_idr_not_1_of_filter_condition"
    "test_insight_idr_not_condition_query"
    "test_insight_idr_pipeline_process_creation_field_mapping"
    "test_insight_idr_pipeline_simple"
    "test_insight_idr_pipeline_unsupported_aggregate_conditions_rule_type"
    "test_insight_idr_pipeline_web_proxy_field_mapping"
    "test_insight_idr_re_query"
    "test_insight_idr_simple_contains_query"
    "test_insight_idr_simple_endswith_query"
    "test_insight_idr_simple_eq_nocase_query"
    "test_insight_idr_simple_startswith_query"
    "test_insight_idr_single_quote"
    "test_insight_idr_startswith_any_query"
    "test_insight_idr_triple_quote"
    "test_insight_idr_value_eq_and_query"
    "test_insight_idr_value_eq_or_query"
    "test_insight_idr_value_in_list_query"
  ];

  meta = {
    description = "Library to support the Rapid7 InsightIDR backend for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-insightidr";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-insightidr/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
