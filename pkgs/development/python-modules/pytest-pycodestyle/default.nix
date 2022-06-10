{ lib
, buildPythonPackage
, fetchPypi
, pycodestyle
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-pycodestyle";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bA4qBznDUNTc/+ZouV9j85D86LTme0+yNiCN1tDPZTA=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    pycodestyle
  ];

  meta = with lib; {
    description = "pytest plugin to run pycodestyle";
    homepage = "https://github.com/henry0312/pytest-pycodestyle";
    license = licenses.mit;
    maintainer = with maintainers; [ turion ];
  };
}
