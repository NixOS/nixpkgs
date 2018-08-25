{ stdenv, fetchFromGitHub, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  pname = "python-dotenv";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "theskumar";
    repo = "python-dotenv";
    rev = "v${version}";
    sha256 = "1jr0dd8996mx6g359fv4wbcafi2mpvsjjcxqkab5whfd54q9nfpf";
  };

  propagatedBuildInputs = with pythonPackages; [ click ];

  checkInputs = with pythonPackages; [
    ipython
    pytest
    sh
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/theskumar/python-dotenv;
    description = "Reads the key,value pair from .env file and adds them to environment variable";
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = [];
  };
}
