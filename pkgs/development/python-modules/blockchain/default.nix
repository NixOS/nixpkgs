{ lib
, buildPythonPackage
, fetchFromGitHub
, future
}:

buildPythonPackage rec {
  pname = "blockchain";
  version = "1.4.4";

  src = fetchFromGitHub {
     owner = "blockchain";
     repo = "api-v1-client-python";
     rev = "1.4.4";
     sha256 = "1ijxfb6jr5wr0vv0p0l2kvq4n2bbjikkcb6iyfgqyqv07qjdqnhx";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "enum-compat" ""
  '';

  propagatedBuildInputs = [
    future
  ];

  # tests are interacting with the API and not mocking the calls
  doCheck = false;

  pythonImportsCheck = [ "blockchain" ];

  meta = with lib; {
    description = "Python client Blockchain Bitcoin Developer API";
    homepage = "https://github.com/blockchain/api-v1-client-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
