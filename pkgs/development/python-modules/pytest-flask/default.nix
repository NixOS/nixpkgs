{ lib, buildPythonPackage, fetchPypi, pytest, flask, werkzeug, setuptools-scm, isPy27 }:

buildPythonPackage rec {
  pname = "pytest-flask";
  version = "1.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "46fde652f77777bf02dc91205aec4ce20cdf2acbbbd66a918ab91f5c14693d3d";
  };

  doCheck = false;

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    flask
    werkzeug
  ];

  nativeBuildInputs = [ setuptools-scm ];

  meta = with lib; {
    description = "A set of pytest fixtures to test Flask applications";
    homepage = "https://pytest-flask.readthedocs.io/";
    changelog = "https://github.com/pytest-dev/pytest-flask/blob/${version}/docs/changelog.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ vanschelven ];
  };
}
