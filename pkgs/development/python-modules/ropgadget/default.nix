{ lib
, buildPythonPackage
, fetchFromGitHub
, capstone
}:

buildPythonPackage rec {
  pname = "ropgadget";
  version = "6.6";

  src = fetchFromGitHub {
    owner = "JonathanSalwan";
    repo = "ROPgadget";
    rev = "v${version}";
    sha256 = "1i0gx0cwhxk6d8byvck17hh83szz3k6ndd118ha3q0r0msap0lz1";
  };

  propagatedBuildInputs = [
    capstone
  ];

  # Test suite is working with binaries
  doCheck = false;

  pythonImportsCheck = [
    "ropgadget"
  ];

  meta = with lib; {
    description = "Tool to search for gadgets in binaries to facilitate ROP exploitation";
    homepage = "http://shell-storm.org/project/ROPgadget/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bennofs ];
  };
}
