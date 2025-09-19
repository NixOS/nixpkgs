{
  lib,
  beancount,
  click,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  python-dateutil,
  pytestCheckHook,
  setuptools,
  tatsu-lts,
}:
buildPythonPackage rec {
  pname = "beanquery";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beancount";
    repo = "beanquery";
    tag = "v${version}";
    hash = "sha256-O7+WCF7s50G14oNTvJAOTvgSoNR9fWcn/m1jv7RHmK8=";
  };

  patches = [
    (fetchpatch2 {
      name = "beancount-workaround.patch";
      url = "https://github.com/beancount/beanquery/commit/aa0776285a25baeedf151e9f582bef0314f76004.patch?full_index=1";
      hash = "sha256-hWL1CDsBSbMqufEQrtEncmyUr5L5VJI+i4xQtnAvQd8=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    beancount
    click
    python-dateutil
    tatsu-lts
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "beanquery"
  ];

  meta = with lib; {
    homepage = "https://github.com/beancount/beanquery";
    description = "Beancount Query Language";
    longDescription = ''
      A customizable light-weight SQL query tool that works on tabular data,
      including Beancount.
    '';
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ alapshin ];
    mainProgram = "bean-query";
  };
}
