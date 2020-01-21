{ lib, buildPythonPackage, fetchPypi
, black
, pytest
, setuptools_scm
, toml
}:

buildPythonPackage rec {
  pname = "pytest-black";
  version = "0.3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03gwwy1h3qnfh6vpfhgsa5ag53a9sw1g42sc2s8a2hilwb7yrfvm";
  };

  patches = [ ./black-version.patch ];
  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ black pytest toml ];

  meta = with lib; {
    description = "A pytest plugin to enable format checking with black";
    homepage = "https://github.com/shopkeep/pytest-black";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
