{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, pytest, pytest-metadata, setuptools_scm }:

buildPythonPackage rec {
  pname = "pytest-html";
  version = "2.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14cy5iixi6i8i5r5xvvkhwk48zgxnb1ypbp0g1343mwfdihshic6";
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
