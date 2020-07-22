{ lib, buildPythonPackage, fetchPypi, setuptools_scm
, inflect, more-itertools, six, pytest
}:

buildPythonPackage rec {
  pname = "jaraco.itertools";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6447d567f57efe5efea386265c7864652e9530830a1b80f43e60b4f222b9ab84";
  };

  nativeBuildInputs = [ setuptools_scm ];

  patches = [
    ./0001-Don-t-run-flake8-checks-during-the-build.patch
  ];

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
