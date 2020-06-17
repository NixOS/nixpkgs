{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, pytest, pytest-metadata, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-html";
  version = "2.1.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1iap9rzxx9pkvz6im3px8xj37pb098lvvf9yiqh93qq5w68w6jka";
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
