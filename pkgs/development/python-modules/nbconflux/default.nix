{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  nbconvert,
  pytestCheckHook,
  requests,
  responses,
}:

buildPythonPackage rec {
  pname = "nbconflux";
  version = "0.7.0";
  format = "setuptools";
  disabled = isPy27; # no longer compatible with python 2 urllib

  src = fetchFromGitHub {
    owner = "Valassis-Digital-Media";
    repo = "nbconflux";
    rev = "refs/tags/${version}";
    hash = "sha256-kHIuboFKLVsu5zlZ0bM1BUoQR8f1l0XWcaaVI9bECJw=";
  };

  propagatedBuildInputs = [
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
