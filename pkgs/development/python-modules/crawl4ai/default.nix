{
  lib,
  aiofiles,
  aiohttp,
  aiosqlite,
  alphashape,
  anyio,
  beautifulsoup4,
  brotli,
  buildPythonPackage,
  chardet,
  click,
  cssselect,
  fake-useragent,
  fetchFromGitHub,
  h2,
  httpx,
  humanize,
  lark,
  litellm,
  lxml,
  nltk,
  numpy,
  patchright,
  pillow,
  playwright-stealth,
  playwright,
  psutil,
  pydantic,
  pyopenssl,
  pypdf,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  pyyaml,
  rank-bm25,
  requests,
  rich,
  scikit-learn,
  selenium,
  sentence-transformers,
  setuptools,
  shapely,
  snowballstemmer,
  tokenizers,
  torch,
  transformers,
  unclecode-litellm,
  writableTmpDirAsHomeHook,
  xxhash,
}:

buildPythonPackage (finalAttrs: {
  pname = "crawl4ai";
  version = "0.9.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "unclecode";
    repo = "crawl4ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MHCnhp7itaJ6y++uUCnObBjiJ9Jw/aFBtd35WzDBz1A=";
  };

  pythonRelaxDeps = [
    "lxml"
    "snowballstemmer"
  ];

  pythonRemoveDeps = [ "patchright" ];

  build-system = [
    setuptools
    writableTmpDirAsHomeHook
  ];

  dependencies = [
    aiofiles
    aiohttp
    aiosqlite
    alphashape
    anyio
    beautifulsoup4
    brotli
    chardet
    click
    cssselect
    fake-useragent
    httpx
    humanize
    lark
    litellm
    lxml
    nltk
    numpy
    patchright
    pillow
    playwright
    playwright-stealth
    psutil
    pydantic
    pyopenssl
    python-dotenv
    pyyaml
    rank-bm25
    requests
    rich
    shapely
    snowballstemmer
    unclecode-litellm
    xxhash
  ];

  optional-dependencies = {
    all = [
      nltk
      pypdf
      scikit-learn
      selenium
      sentence-transformers
      tokenizers
      torch
      transformers
    ];
    cosine = [
      nltk
      sentence-transformers
      torch
      transformers
    ];
    pdf = [ pypdf ];
    sync = [ selenium ];
    torch = [
      nltk
      scikit-learn
      torch
    ];
    transformer = [
      sentence-transformers
      tokenizers
      transformers
    ];
  };

  nativeCheckInputs = [
    h2
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pytestFlags = [ "--continue-on-collection-errors" ];

  disabledTestPaths = [
    # sys.exit(1) that crashes pytest
    "tests/test_cloud_bugs_batch.py"
    # Require docker, browser, LLM API, network and parts
    "deploy/docker/"
    "docs/examples/"
    "tests/adaptive/"
    "tests/async/"
    "tests/browser/"
    "tests/cache_validation/test_end_to_end.py"
    "tests/cache_validation/test_real_domains.py"
    "tests/deep_crawling/test_deep_crawl_resume_integration.py"
    "tests/docker/test_config_object.py"
    "tests/docker/test_docker.py"
    "tests/docker/test_filter_deep_crawl.py"
    "tests/docker/test_hooks_client.py"
    "tests/docker/test_hooks_comprehensive.py"
    "tests/docker/test_hooks_utility.py"
    "tests/docker/test_llm_params.py"
    "tests/docker/test_rest_api_deep_crawl.py"
    "tests/docker/test_server.py"
    "tests/docker/test_server_requests.py"
    "tests/docker/test_server_token.py"
    "tests/general/test_async_crawler_strategy.py"
    "tests/general/test_async_url_seeder_bm25.py"
    "tests/general/test_async_webcrawler.py"
    "tests/general/test_bff_scoring.py"
    "tests/general/test_cache_context.py"
    "tests/general/test_crawlers.py"
    "tests/general/test_deep_crawl_filters.py"
    "tests/general/test_download_file.py"
    "tests/general/test_http_crawler_strategy.py"
    "tests/general/test_llm_filter.py"
    "tests/general/test_max_scroll.py"
    "tests/general/test_mhtml.py"
    "tests/general/test_schema_builder.py"
    "tests/mcp/"
    "tests/memory/test_docker_config_gen.py"
    "tests/integration/test_domain_mapper_e2e.py"
    "tests/general/test_network_console_capture.py"
    "tests/general/test_robot_parser.py"
    "tests/general/test_stream.py"
    "tests/general/test_stream_dispatch.py"
    "tests/proxy/"
    "tests/regression/"
    "tests/releases/"
    "tests/test_arun_many.py"
    "tests/test_cdp_changes.py"
    "tests/test_cli_docs.py"
    "tests/test_config_selection.py"
    "tests/test_docker.py"
    "tests/test_docker_api_with_llm_provider.py"
    "tests/test_eval_security_adversarial.py"
    "tests/test_issue_1594_mcp_sse.py"
    "tests/test_issue_1611_llm_provider.py"
    "tests/test_issue_1748_screenshot_scroll_delay.py"
    "tests/test_issue_1750_screenshot_scan_full_page.py"
    "tests/test_issue_1850_mcp_sse.py"
    "tests/test_link_extractor.py"
    "tests/test_llm_extraction_parallel_issue_1055.py"
    "tests/test_llm_simple_url.py"
    "tests/test_llmtxt.py"
    "tests/test_main.py"
    "tests/test_multi_config.py"
    "tests/test_prefetch_integration.py"
    "tests/test_prefetch_regression.py"
    "tests/test_pr_1435_redirected_status_code.py"
    "tests/test_pr_1463_device_scale_factor.py"
    "tests/test_pyopenssl_update.py"
    "tests/test_raw_html_browser.py"
    "tests/test_raw_html_edge_cases.py"
    "tests/test_raw_html_redirected_url.py"
    "tests/test_scraping_strategy.py"
    "tests/test_virtual_scroll.py"
    "tests/test_web_crawler.py"
  ];

  disabledTests = [
    # Tests require network access
    "test_client_is_built_once_and_reused"
    "test_reused_client_extracts_from_multiple_urls"
    "test_clones_share_one_client"
    "test_reused_client_checks_multiple_urls"
    "test_concurrent_host_scanning"
    "test_domain_with_scheme"
    "test_probe_without_crt"
    "test_examples"
    "test_missing_url"
    "test_basic_crawl"
    # Tests require LLM API
    "test_map_query_uses_query_config"
    "test_legacy_single_config_for_query"
    # Assertions Errors
    "allowed_types5"
    "allowed_types16"
    "test_empty_href"
    "test_href_is_only_fragment"
    "test_href_with_fragment"
    "test_invalid_base_url_netloc"
    "test_invalid_base_url_scheme"
    # Test checks GitHub Actions version
    "test_no_v4_or_v5_checkout_remaining"
  ];

  pythonImportsCheck = [ "crawl4ai" ];

  meta = {
    description = "LLM Friendly Web Crawler & Scraper";
    homepage = "https://github.com/unclecode/crawl4ai";
    changelog = "https://github.com/unclecode/crawl4ai/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
