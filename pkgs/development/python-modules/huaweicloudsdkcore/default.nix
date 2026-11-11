{
  lib,
  buildPythonPackage,
  certifi,
  defusedxml,
  fetchFromGitHub,
  hatchling,
  pyasn1,
  pymongo,
  pyyaml,
  requests-toolbelt,
  simplejson,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "huaweicloudsdkcore";
  version = "3.1.213";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huaweicloud";
    repo = "huaweicloud-sdk-python-v3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Bir0DWGN0xpfUfC9KMwu/kfzM8jWaqC7S6BUat49zEY=";
  };

  sourceRoot = "${finalAttrs.src.name}/huaweicloud-sdk-core";

  pythonRelaxDeps = [
    "pyasn1"
    "pymongo"
  ];

  build-system = [ hatchling ];

  dependencies = [
    certifi
    defusedxml
    pyasn1
    pymongo
    pyyaml
    requests-toolbelt
    simplejson
    six
  ];

  # All components are stored in a mono repo
  doCheck = false;

  pythonImportsCheck = [ "huaweicloudsdkcore" ];

  meta = {
    description = "Core module of Huawei Cloud Python SDK";
    homepage = "https://github.com/huaweicloud/huaweicloud-sdk-python-v3";
    changelog = "https://github.com/huaweicloud/huaweicloud-sdk-python-v3/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
