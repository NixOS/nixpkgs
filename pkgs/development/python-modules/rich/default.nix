{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, pytest, typing-extensions, pygments, recommonmark, colorama }:

buildPythonPackage rec {
  pname = "rich";
  version = "8.0.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "willmcgugan";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hv27b22x7dbx1i7nzsd8y8fymmvdak2hcx9242jwk4c1a7jr151";
  };

  postPatch = ''
    sed -i 's/setuptools.setup(name="rich")/setuptools.setup(name="rich", packages=setuptools.find_packages())/g' setup.py
  '';

  propagatedBuildInputs = [ typing-extensions pygments recommonmark colorama ];

  checkInputs = [ pytest ];
  checkPhase = "pytest";
  pythonImportsCheck = [ "rich" ];

  meta = with lib; {
    description = "Library for rich text and beautiful formatting in the terminal";
    homepage = "https://github.com/willmcgugan/rich";
    license = licenses.mit;
    maintainers = [ maintainers.sengaya ];
  };
}
