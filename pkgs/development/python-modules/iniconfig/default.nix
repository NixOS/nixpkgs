{ lib, buildPythonPackage, fetchPypi, setuptools-scm }:

buildPythonPackage rec {
  pname = "iniconfig";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc3af051d7d14b2ee5ef9969666def0cd1a000e121eaea580d4a313df4b37f32";
  };

  nativeBuildInputs = [ setuptools-scm ];

  doCheck = false; # avoid circular import with pytest
  pythonImportsCheck = [ "iniconfig" ];

  meta = with lib; {
    description = "brain-dead simple parsing of ini files";
    homepage = "https://github.com/pytest-dev/iniconfig";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
