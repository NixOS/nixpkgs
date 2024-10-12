{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-ptrace";
  version = "0.9.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Vrv+9E6vOne+SBOMyldnzfRx6CeP4Umfm3LxUZB/Jc8=";
  };

  nativeBuildInputs = [ setuptools ];

  # requires distorm, which is optionally
  doCheck = false;

  meta = with lib; {
    description = "Python binding of ptrace library";
    homepage = "https://github.com/vstinner/python-ptrace";
    changelog = "https://github.com/vstinner/python-ptrace/blob/${version}/doc/changelog.rst";
    license = licenses.gpl2;
    maintainers = with maintainers; [ mic92 ];
  };
}
