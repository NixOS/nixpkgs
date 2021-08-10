{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  nose,
  six,
  typing ? null,
  isPy27,
}:

buildPythonPackage rec {
  pname = "class-registry";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "todofixthis";
    repo = pname;
    rev = version;
    sha256 = "0gpvq4a6qrr2iki6b4vxarjr1jrsw560m2qzm5bb43ix8c8b7y3q";
  };

  propagatedBuildInputs = [ six ] ++ lib.optional isPy27 typing;
  checkInputs = [ nose ];

  # Tests currently failing.
  doCheck = false;

  meta = {
    description = "Factory+Registry pattern for Python classes.";
    homepage = "https://class-registry.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kevincox ];
  };
}
