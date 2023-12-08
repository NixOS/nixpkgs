{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "naturalsort";
  version = "1.5.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-naturalsort";
    rev = version;
    sha256 = "0w43vlddzh97hffnvxp2zkrns9qyirx5g8ijxnxkbx1c4b4gq5ih";
  };

  meta = with lib; {
    description = "Simple natural order sorting API for Python that just works";
    homepage = "https://github.com/xolox/python-naturalsort";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
