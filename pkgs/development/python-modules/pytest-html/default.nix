{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, pytest, pytest-metadata, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-html";
  version = "3.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "407adfe8c748a6bb7e68a430ebe3766ffe51e43fc5442f78b261229c03078be4";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ pytest pytest-metadata ];

  meta = with stdenv.lib; {
    description = "Plugin for generating HTML reports";
    homepage = "https://github.com/pytest-dev/pytest-html";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mpoquet ];
  };
}
