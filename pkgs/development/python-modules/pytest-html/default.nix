{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, pytest, pytest-metadata, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-html";
  version = "3.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a7979e2411aac445870d8cad9a251ab3823bc14f77d065e9ce9a5dff86f697d";
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
