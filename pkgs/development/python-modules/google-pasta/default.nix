{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "google-pasta";
  version = "0.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zmqfvy28i2509277s6sz098kddd16cx21vpxyc8xml1nclcxlbr";
  };

  propagatedBuildInputs = [
    six
  ];

  meta = {
    description = "An AST-based Python refactoring library";
    homepage    = https://github.com/google/pasta;
    license     = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timokau ];
  };
}
