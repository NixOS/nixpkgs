{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "pypck";
<<<<<<< HEAD
  version = "0.9.9";
  pyproject = true;

=======
  version = "0.8.12";
  pyproject = true;

  disabled = pythonOlder "3.11";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "alengwenus";
    repo = "pypck";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-EsPfPRYp75GML9JMoFPf5U8obh51LjIkg/FFRNkrEOY=";
=======
    hash = "sha256-XXlHgr8/Cl3eu1vIDl/XykB2gv8PPkPIFEBG30yUue0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    echo "${version}" > VERSION
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

<<<<<<< HEAD
=======
  pytestFlags = [ "--asyncio-mode=auto" ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "test_connection_lost" ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pypck" ];

<<<<<<< HEAD
  meta = {
    description = "LCN-PCK library written in Python";
    homepage = "https://github.com/alengwenus/pypck";
    changelog = "https://github.com/alengwenus/pypck/releases/tag/${src.tag}";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "LCN-PCK library written in Python";
    homepage = "https://github.com/alengwenus/pypck";
    changelog = "https://github.com/alengwenus/pypck/releases/tag/${src.tag}";
    license = licenses.epl20;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
