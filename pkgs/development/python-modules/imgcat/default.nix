{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  matplotlib,
  numpy,
  pillow,
  pytestCheckHook,
  setuptools,
  tensorflow,
  torch,
}:

buildPythonPackage rec {
  pname = "imgcat";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wookayin";
    repo = "python-imgcat";
    rev = "refs/tags/v${version}";
    hash = "sha256-FsLa8Z4aKuj3E5twC2LTXZDM0apmyYfgeyZQu/wLdAo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner<5.0'" ""
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    matplotlib
    numpy
    pillow
    pytestCheckHook
    tensorflow
    torch
  ];

  pythonImportsCheck = [ "imgcat" ];

  meta = {
    description = "Imgcat in Python";
    homepage = "https://github.com/wookayin/python-imgcat";
    changelog = "https://github.com/wookayin/python-imgcat/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
