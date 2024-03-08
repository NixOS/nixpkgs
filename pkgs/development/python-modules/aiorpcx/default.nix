{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, attrs
}:

buildPythonPackage rec {
  pname = "aiorpcx";
  version = "0.22.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "aiorpcX";
    sha256 = "0lx54bcinp44fmr8q4bbffsqbkg8kdcwykf9i5jj0bj3sfzgf9k0";
  };

  propagatedBuildInputs = [ attrs ];

  disabled = pythonOlder "3.6";

  # Checks needs internet access
  doCheck = false;

  pythonImportsCheck = [ "aiorpcx" ];

  meta = with lib; {
    description = "Transport, protocol and framing-independent async RPC client and server implementation";
    homepage = "https://github.com/kyuupichan/aiorpcX";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
