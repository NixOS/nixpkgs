{
  lib,
  buildPythonPackage,
  fetchPypi,
  docopt,
  netifaces,
}:

buildPythonPackage rec {
  pname = "onkyo-eiscp";
  version = "1.2.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dhq7FsZUoRNnY7kn0JQXTUHygoCeROoyzUfhmd152ck=";
  };

  propagatedBuildInputs = [
    docopt
    netifaces
  ];

  meta = with lib; {
    description = "Control Onkyo receivers over ethernet";
    mainProgram = "onkyo";
    homepage = "https://github.com/miracle2k/onkyo-eiscp";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
