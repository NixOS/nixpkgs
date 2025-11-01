{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  jsonpath-ng,
  lupa,
  pyprobables,
  pytest-asyncio_0,
  pytest-mock,
  pytestCheckHook,
  redis,
  redisTestHook,
  sortedcontainers,
  valkey,
}:

buildPythonPackage rec {
  pname = "fakeredis";
  version = "2.32.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dsoftwareinc";
    repo = "fakeredis-py";
    tag = "v${version}";
    hash = "sha256-esouWM32qe4iO5AcRC0HuUF+lwEDHnyXoknwqsZhr+o=";
  };

  build-system = [ hatchling ];

  dependencies = [
    redis
    sortedcontainers
  ];

  optional-dependencies = {
    lua = [ lupa ];
    json = [ jsonpath-ng ];
    bf = [ pyprobables ];
    cf = [ pyprobables ];
    probabilistic = [ pyprobables ];
    valkey = [ valkey ];
  };

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio_0
    pytest-mock
    pytestCheckHook
    redisTestHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "fakeredis" ];

  disabledTestMarks = [ "slow" ];

  disabledTests = [
    # redis.exceptions.ResponseError: unknown command 'JSON.SET',...
    "test_acl_log"
    "test_arrappend"
    "test_arrindex"
    "test_arrinsert"
    "test_arrlen"
    "test_arrpop"
    "test_arrtrim"
    "test_bf_add"
    "test_bf_card"
    "test_bf_exists"
    "test_bf_info_resp2"
    "test_bf_info_resp3"
    "test_bf_insert"
    "test_bf_madd"
    "test_bf_mexists"
    "test_bf_reserve"
    "test_bf_scandump_and_loadchunk"
    "test_cf_count_non_existing"
    "test_cf_exists_and_del"
    "test_client"
    "test_cms_create"
    "test_cms_incrby"
    "test_cms_info"
    "test_cms_merge"
    "test_create_bf"
    "test_create_cf"
    "test_decode_null"
    "test_decode_response_disabaled_null"
    "test_json_commands_in_pipeline"
    "test_json_delete_with_dollar"
    "test_json_et_non_dict_value"
    "test_json_get_jset"
    "test_json_merge"
    "test_json_setbinarykey"
    "test_json_setgetdeleteforget"
    "test_jsonclear"
    "test_jsonget"
    "test_jsonmget"
    "test_jsonmgettest_jsonmget_should_succeed"
    "test_jsonset_existential_modifiers_should_succeed"
    "test_jsonsetnx"
    "test_jsonstrlen"
    "test_mset"
    "test_nonascii_setgetdelete"
    "test_numincrby"
    "test_nummultby"
    "test_objkeys"
    "test_objlen"
    "test_set_file"
    "test_set_path"
    "test_strappend"
    "test_tdigest"
    "test_toggle_dollar"
    "test_toggle"
    "test_type"
  ];

  preCheck = ''
    redisTestPort=6390
  '';

  meta = with lib; {
    description = "Fake implementation of Redis API";
    homepage = "https://github.com/dsoftwareinc/fakeredis-py";
    changelog = "https://github.com/cunla/fakeredis-py/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
