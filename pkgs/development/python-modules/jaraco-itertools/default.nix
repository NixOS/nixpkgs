{ lib, buildPythonPackage, fetchPypi, setuptools-scm
, inflect, more-itertools, six, pytest
}:

buildPythonPackage rec {
  pname = "jaraco-itertools";
  version = "6.4.1";
  format = "pyproject";

  src = fetchPypi {
    pname = "jaraco.itertools";
    inherit version;
    hash = "sha256-MU/OVi67RepIIqmLvXsi5f6sfVEY28Gk8ess0Ea/+kc=";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ inflect more-itertools six ];
  nativeCheckInputs = [ pytest ];

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
