{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  python-dotenv,
}:

buildPythonPackage rec {
  pname = "pytest-dotenv";
  version = "0.5.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "LcbDrG2HZMccbSgE6QLQ/4EPoZaS6V/hOK78mxqnNzI=";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ python-dotenv ];

  nativeCheckInputs = [ pytest ];

  meta = with lib; {
    description = "A pytest plugin that parses environment files before running tests";
    homepage = "https://github.com/quiqua/pytest-dotenv";
    license = licenses.mit;
    maintainers = with maintainers; [ cleeyv ];
  };
}
