{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nbconvert,
  pytestCheckHook,
  requests,
  responses,
  setuptools,
  versioneer,
}:

buildPythonPackage rec {
  pname = "nbconflux";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vericast";
    repo = "nbconflux";
    tag = version;
    hash = "sha256-kHIuboFKLVsu5zlZ0bM1BUoQR8f1l0XWcaaVI9bECJw=";
  };

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    nbconvert
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  patches = [
    # The original setup.py file is missing commas in the install_requires list
    ./setup-py.patch
  ];

  postPatch = ''
    # remove vendorized versioneer.py
    rm versioneer.py
  '';

  JUPYTER_PATH = "${nbconvert}/share/jupyter";
  disabledTests = [
    "test_post_to_confluence"
    "test_optional_components"
  ];

  meta = with lib; {
    description = "Converts Jupyter Notebooks to Atlassian Confluence (R) pages using nbconvert";
    mainProgram = "nbconflux";
    homepage = "https://github.com/Valassis-Digital-Media/nbconflux";
    license = licenses.bsd3;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
