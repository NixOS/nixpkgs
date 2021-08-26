{ lib, buildPythonPackage, fetchPypi, pythonOlder
, pytest, pytest-metadata, setuptools-scm }:

buildPythonPackage rec {
  pname = "pytest-html";
  version = "3.1.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ee1cf319c913d19fe53aeb0bc400e7b0bc2dbeb477553733db1dad12eb75ee3";
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
