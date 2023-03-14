{ lib, buildPythonPackage, fetchPypi, pythonOlder
, pytest, pytest-metadata, setuptools-scm }:

buildPythonPackage rec {
  pname = "pytest-html";
  version = "3.2.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xOL0uwv/xDf1GtIXSoo+cd+Bu8L2iUYE5gSvGPvmh8M=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  buildInputs = [ pytest ];
  propagatedBuildInputs = [ pytest-metadata ];

  meta = with lib; {
    description = "Plugin for generating HTML reports";
    homepage = "https://github.com/pytest-dev/pytest-html";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mpoquet ];
  };
}
