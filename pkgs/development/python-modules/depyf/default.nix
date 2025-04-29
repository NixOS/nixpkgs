{
  lib,
  buildPythonPackage,
  fetchPypi,
  astor,
  dill,
  filelock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "depyf";
  version = "0.18.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uZ8MODvpSa5F1dYG/kRMcfN1tVpXuNayDnhWZw1SEw0=";
  };

  # don't try to read git commit
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'commit_id = get_git_commit_id()' 'commit_id = None'
  '';

  propagatedBuildInputs = [
    astor
    dill
    filelock
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "depyf" ];

  meta = with lib; {
    description = "Decompile python functions, from bytecode to source code";
    homepage = "https://github.com/thuml/depyf";
    license = licenses.mit;
  };
}
