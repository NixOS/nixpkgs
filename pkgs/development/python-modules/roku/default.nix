{ lib, fetchFromGitHub, buildPythonPackage, requests, pytest, flask, isPy27
}:

buildPythonPackage rec {
  version = "4.1";
  format = "setuptools";
  pname = "roku";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jcarbaugh";
    repo = "python-roku";
    rev = "v${version}";
    sha256 = "09mq59kjll7gj1srw4qc921ncsm7cld95sbz5v3p2bwmgckpqza7";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [ pytest flask ];
  pythonImportsCheck = [ "roku" ];

  meta = with lib; {
    description = "Screw remotes. Control your Roku with Python.";
    homepage = "https://github.com/jcarbaugh/python-roku";
    license = licenses.bsd3;
  };
}
