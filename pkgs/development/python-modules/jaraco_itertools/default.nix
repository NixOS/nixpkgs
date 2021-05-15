{ lib, buildPythonPackage, fetchPypi, setuptools_scm
, inflect, more-itertools, six, pytest
}:

buildPythonPackage rec {
  pname = "jaraco.itertools";
  version = "6.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6939e47806a39330a9f9772bf9ea910da39abc159ff2579d454a763358553439";
  };

  pythonNamespaces = [ "jaraco" ];

  nativeBuildInputs = [ setuptools_scm ];

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
