{
  lib,
  attrs,
  buildPythonPackage,
  click,
  commoncode,
  dockerfile-parse,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "container-inspector";
  version = "33.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vtC42yq59vTE+4tF5CSm9zszj8goOP5i6+NMF2n4T1Q=";
  };

  dontConfigure = true;

  postPatch = ''
    # PEP440 support was removed in newer setuptools, https://github.com/nexB/container-inspector/pull/51
    substituteInPlace setup.cfg \
      --replace ">=3.7.*" ">=3.7"
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    attrs
    click
    dockerfile-parse
    commoncode
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "container_inspector" ];

  meta = with lib; {
    description = "Suite of analysis utilities and command line tools for container images";
    homepage = "https://github.com/nexB/container-inspector";
    changelog = "https://github.com/nexB/container-inspector/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
