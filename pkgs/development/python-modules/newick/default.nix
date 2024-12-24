{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "newick";
  version = "1.9.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dlce-eva";
    repo = "python-newick";
    rev = "v${version}";
    hash = "sha256-TxyR6RYvy2oIcDNZnHrExtPYGspyWOtZqNy488OmWwk=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  postPatch = ''
    # remove coverage arguments to pytest
    sed -i '/--cov/d' setup.cfg
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "newick" ];

  meta = with lib; {
    description = "Python package to read and write the Newick format";
    homepage = "https://github.com/dlce-eva/python-newick";
    license = licenses.asl20;
    maintainers = with maintainers; [ alxsimon ];
  };
}
