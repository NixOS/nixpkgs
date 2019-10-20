{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, isPy27
, aenum
, wrapt
, typing
, pyserial
, nose
, mock
, hypothesis
, future
, pytest
, pytest-timeout }:

buildPythonPackage rec {
  pname = "python-can";
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1giv9s6w90lalxsijgnxzynygkckcfyaxnxsldbwv0784vwy1jcd";
  };

  propagatedBuildInputs = [ wrapt pyserial aenum ] ++ lib.optional (pythonOlder "3.5") typing;
  checkInputs = [ nose mock pytest pytest-timeout hypothesis future ];

  # Tests won't work with hypothesis 4.7.3 under Python 2. So skip the tests in
  # that case. This clause can be removed once hypothesis has been upgraded in
  # nixpkgs.
  doCheck = !(isPy27 && (hypothesis.version == "4.7.3"));

  # Add the scripts to PATH
  checkPhase = ''
    PATH=$out/bin:$PATH pytest -c /dev/null
  '';

  meta = with lib; {
    homepage = https://github.com/hardbyte/python-can;
    description = "CAN support for Python";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ sorki ];
  };
}
