{ lib, buildPythonPackage, fetchPypi
, black
, pytest
, setuptools_scm
, toml
}:

buildPythonPackage rec {
  pname = "pytest-black";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c743dfeffe6b2cb25c0ed1a84cc306dff4b504b713b5a6d1bc3824fa73a7d693";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ black pytest toml ];

  meta = with lib; {
    description = "A pytest plugin to enable format checking with black";
    homepage = "https://github.com/shopkeep/pytest-black";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
