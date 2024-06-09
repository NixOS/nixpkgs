{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "lazy-object-proxy";
  version = "1.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eCR7bUX0OlLvNcJbVYFFnoURciVAikEoo9r4v5ZIrGk=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace ",<6.0" ""
    substituteInPlace setup.cfg --replace ",<6.0" ""
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  # Broken tests. Seem to be fixed upstream according to Travis.
  doCheck = false;

  meta = with lib; {
    description = "A fast and thorough lazy object proxy";
    homepage = "https://github.com/ionelmc/python-lazy-object-proxy";
    license = with licenses; [ bsd2 ];
  };
}
