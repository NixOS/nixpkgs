{ lib
, buildPythonPackage
, fetchPypi
, codecov
, coverage
, flake8
, nose
, six
, pyyaml
, mock
}:

buildPythonPackage rec {
  pname = "ddt";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c00ikkxr7lha97c81k938bzhgd4pbwamkjn0h4nkhr3xk00zp6n";
  };

  checkInputs = [
    codecov
    coverage
    flake8
    nose
    six
    pyyaml
    mock
  ];

  meta = with lib;{
    description = "Data-Driven/Decorated Tests, a library to multiply test cases";

    homepage = https://github.com/txels/ddt;

    license = licenses.mit;
  };

}
