{ lib, buildPythonPackage, fetchPypi, setuptools-scm
, inflect, more-itertools, six, pytest
}:

buildPythonPackage rec {
  pname = "jaraco.itertools";
  version = "6.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1775bfcad5de275a540a36720c5ab34594ea1dbe7ffefa32099b0129c5604608";
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
