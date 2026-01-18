{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  streamlit,
}:

buildPythonPackage rec {
  pname = "extra-streamlit-components";
  version = "0.1.81";
  pyproject = true;

  src = fetchPypi {
    pname = "extra_streamlit_components";
    inherit version;
    hash = "sha256-65vre6z+iz0jjxiIohx4rGz6VpNBvkhLygjD6gsV8g0=";
  };

  build-system = [ setuptools ];

  dependencies = [ streamlit ];

  pythonImportsCheck = [ "extra_streamlit_components" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Additional components for streamlit";
    homepage = "https://pypi.org/project/extra-streamlit-components/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
