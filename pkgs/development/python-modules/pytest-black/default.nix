{ lib, buildPythonPackage, fetchPypi
, black
, pytest
, setuptools_scm
, toml
}:

buildPythonPackage rec {
  pname = "pytest-black";
  version = "0.3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04lppqydxm0f3f3x0l8hj7v0j6d8syj34jc37yzqwqcyqsnaga81";
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
