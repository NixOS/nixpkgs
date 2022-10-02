{ lib, buildPythonPackage, fetchPypi, setuptools-scm
, inflect, more-itertools, six, pytest
}:

buildPythonPackage rec {
  pname = "jaraco.itertools";
  version = "6.2.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YJjts3xrgCPzeU1CWIoTv3WyygK0D/l5XIRry+DBtGw=";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ inflect more-itertools six ];
  checkInputs = [ pytest ];

  # tests no longer available through pypi
  doCheck = false;
  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [ "jaraco.itertools" ];

  meta = with lib; {
    description = "Tools for working with iterables";
    homepage = "https://github.com/jaraco/jaraco.itertools";
    license = licenses.mit;
  };
}
