{
  buildPythonPackage,
  python,
  fetchFromGitHub,
  lib,
  requests,
  pyyaml,
  setuptools,
  wheel,
  nodejs,
  ruby,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "naked";
  version = "0.1.32";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrissimpkins";
    repo = "naked";
    rev = "v${version}";
    hash = "sha256-KhygnURFggvUTR9wwWtORtfQES8ANd5sIaCONvIhfRM=";
  };

  postPatch = ''
    # fix hardcoded absolute paths
    substituteInPlace tests/test_SYSTEM*.py \
      --replace-fail /Users/ces/Desktop/code/naked/tests/ "$PWD"/tests/
    substituteInPlace lib/Naked/toolshed/c/*.c \
      --replace-fail /Users/ces/Desktop/code/naked/lib/ $out/${python.sitePackages}/
  '';

  nativeBuildInputs = [
    wheel
    setuptools
  ];

  propagatedBuildInputs = [
    requests
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    nodejs
    ruby
  ];

  preCheck = ''
    cd tests

    PATH=$PATH:$out/bin
  '';

  disabledTestPaths = [ "testfiles" ];

  disabledTests = [
    # test_NETWORK.py
    "test_http_get"
    "test_http_get_binary_file_absent"
    "test_http_get_binary_file_exists"
    "test_http_get_bin_type"
    "test_http_get_follow_redirects"
    "test_http_get_follow_redirects_false_content"
    "test_http_get_follow_redirects_false_on_nofollow_arg"
    "test_http_get_response_check_200"
    "test_http_get_response_check_301"
    "test_http_get_response_check_404"
    "test_http_get_response_obj_present"
    "test_http_get_ssl"
    "test_http_get_status_check_true"
    "test_http_get_status_ssl"
    "test_http_get_status_ssl_redirect"
    "test_http_get_text_absent"
    "test_http_get_text_exists_request_overwrite"
    "test_http_get_type"
    "test_http_post"
    "test_http_post_binary_file_absent"
    "test_http_post_binary_file_present"
    "test_http_post_binary_file_present_request_overwrite"
    "test_http_post_reponse_status_200"
    "test_http_post_response_status_200_ssl"
    "test_http_post_ssl"
    "test_http_post_status_check_true"
    "test_http_post_text_file_absent"
    "test_http_post_text_file_present_request_overwrite"
    "test_http_post_type"
    # test_SHELL.py
    "test_muterun_missing_option_exitcode"
    # test_SYSTEM.py
    "test_sys_list_all_files"
    "test_sys_list_all_files_cwd"
    "test_sys_list_all_files_emptydir"
    "test_sys_list_filter_files"
    "test_sys_match_files"
    "test_sys_match_files_fullpath"
    "test_sys_meta_file_mod"
    # test_TYPES.py
    "test_xdict_key_random"
    "test_xdict_key_random_sample"
  ];

  pythonImportsCheck = [ "Naked" ];

  meta = with lib; {
    description = "Python command line application framework";
    homepage = "https://github.com/chrissimpkins/naked";
    downloadPage = "https://github.com/chrissimpkins/naked/tags";
    license = licenses.mit;
    maintainers = [ maintainers.lucasew ];
  };
}
