{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  # Dependencies
  addict,
  attrs,
  datasets,
  einops,
  oss2,
  pillow,
  python-dateutil,
  requests,
  scipy,
  setuptools,
  simplejson,
  sortedcontainers,
  tqdm,
  transformers,
  urllib3,
}:
buildPythonPackage rec {
  pname = "modelscope";
  version = "1.21.0";
  src = fetchFromGitHub {
    owner = "modelscope";
    repo = "modelscope";
    tag = "v${version}";
    hash = "sha256-2Ydi6ijsdfBZJBMHqn7/hs1vvaiKvcuoWHtuHbkc1Ok=";
  };

  propagatedBuildInputs = [
    addict
    attrs
    datasets
    einops
    oss2
    pillow
    python-dateutil
    requests
    scipy
    setuptools
    simplejson
    sortedcontainers
    tqdm
    transformers
    urllib3
  ];

  preInstall = ''
    pushd package
  '';

  pythonImportsCheck = [ "modelscope" ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Bring the notion of Model-as-a-Service to life";
    homepage = "https://www.modelscope.cn/";
    license = with lib.licenses; [ asl20 ];
  };
}
