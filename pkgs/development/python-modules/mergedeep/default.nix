{
  lib,
  buildPythonPackage,
  isPy27,
  fetchFromGitHub,
  pytest,
}:

buildPythonPackage rec {
  pname = "mergedeep";
  version = "1.3.4";
  format = "setuptools";
  disabled = isPy27;

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "clarketm";
    repo = "mergedeep";
    rev = "v${version}";
    sha256 = "1msvvdzk33sxzgyvs4fs8dlsrsi7fjj038z83s0yw5h8m8d78469";
  };

  nativeCheckInputs = [ pytest ];
  checkPhase = "pytest";
  pythonImportsCheck = [ "mergedeep" ];

  meta = with lib; {
    homepage = "https://github.com/clarketm/mergedeep";
    description = "A deep merge function for python";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
