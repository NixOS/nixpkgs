{ buildPythonPackage
, fetchFromGitHub
, lib
, marshmallow
  # Check Inputs
, pytestCheckHook
, pytestcov
}:

buildPythonPackage rec {
  pname = "marshmallow-polyfield";
  version = "5.7";

  src = fetchFromGitHub {
    owner = "Bachmann1234";
    repo = pname;
    rev = "v${version}";
    sha256 = "15yx8ib5yx1xx6kq8wnfdmv9zm43k7y33c6zpq5rba6a30v4lcnd";
  };

  propagatedBuildInputs = [
    marshmallow
  ];
  
  # setuptools check can run, but won't find tests
  checkInputs = [ pytestCheckHook pytestcov ];

  meta = with lib; {
    description = "An unofficial extension to Marshmallow to allow for polymorphic fields";
    homepage = "https://github.com/Bachmann1234/marshmallow-polyfield";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}