{ lib
, aliyun-python-sdk-core
, aliyun-python-sdk-kms
, aliyun-python-sdk-sts
, buildPythonPackage
, crcmod
, fetchFromGitHub
, mock
, pycryptodome
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, requests
, six
}:

buildPythonPackage rec {
  pname = "oss2";
  version = "2.16.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aliyun";
    repo = "aliyun-oss-python-sdk";
    rev = version;
    hash = "sha256-Q8U7zMlqpKSoW99MBm9p0AnrGZY7M9oRNImMNJaEjSw=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    requests
    crcmod
    pycryptodome
    aliyun-python-sdk-kms
    aliyun-python-sdk-core
    six
  ];

  nativeCheckInputs = [
    aliyun-python-sdk-sts
    mock
    pytestCheckHook
  ];

  pythonRelaxDeps = true;

  pythonImportsCheck = [
    "oss2"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_api_base.py"
    "tests/test_async_fetch_task.py"
    "tests/test_bucket_cname.py"
    "tests/test_bucket_inventory.py"
    "tests/test_bucket_meta_query.py"
    "tests/test_bucket_replication.py"
    "tests/test_bucket_transfer_acceleration.py"
    "tests/test_bucket_versioning.py"
    "tests/test_bucket_worm.py"
    "tests/test_bucket.py"
    "tests/test_chinese.py"
    "tests/test_crc64_combine.py"
    "tests/test_credentials_provider.py"
    "tests/test_crypto_multipart.py"
    "tests/test_crypto_object.py"
    "tests/test_crypto.py"
    "tests/test_download.py"
    "tests/test_headers.py"
    "tests/test_image.py"
    "tests/test_init.py"
    "tests/test_iterator.py"
    "tests/test_lifecycle_versioning.py"
    "tests/test_list_objects_v2.py"
    "tests/test_live_channel.py"
    "tests/test_multipart.py"
    "tests/test_object_request_payment_versions.py"
    "tests/test_object_request_payment.py"
    "tests/test_object_versioning.py"
    "tests/test_object.py"
    "tests/test_proxy.py"
    "tests/test_put_object_chunked.py"
    "tests/test_qos_info.py"
    "tests/test_request_payment.py"
    "tests/test_select_csv_object.py"
    "tests/test_select_json_object.py"
    "tests/test_server_side_encryotion.py"
    "tests/test_sign.py"
    "tests/test_traffic_limit.py"
    "tests/test_upload.py"
    "tests/test_utils.py"
    "tests/test_website.py"
  ];

  disabledTests = [
    "test_crypto_get_compact_deprecated_kms"
  ];

  meta = with lib; {
    description = "Alibaba Cloud OSS SDK for Python";
    homepage = "https://github.com/aliyun/aliyun-oss-python-sdk";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
