{ lib
, attrs
, buildPythonPackage
, click
, commoncode
, dockerfile-parse
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "container-inspector";
  version = "32.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-J9glnfs6l36/IQoIvE8a+Cw4B8x/6r5UeAU8+T/OiQg=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  dontConfigure = true;

  postPatch = ''
    # PEP440 support was removed in newer setuptools, https://github.com/nexB/container-inspector/pull/51
    substituteInPlace setup.cfg \
      --replace ">=3.7.*" ">=3.7"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    attrs
    click
    dockerfile-parse
    commoncode
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "container_inspector"
  ];

  meta = with lib; {
    description = "Suite of analysis utilities and command line tools for container images";
    homepage = "https://github.com/nexB/container-inspector";
    changelog = "https://github.com/nexB/container-inspector/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
