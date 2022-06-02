{ lib
, buildPythonPackage
, future
, fetchFromGitHub
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pefile";
  version = "2021.9.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "erocarrera";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sr17rmqpr874m8rpkp8xdz8kjshhimbfgq13qy4lscaiznmlf0d";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    future
  ];

  # Test data encrypted
  doCheck = false;

  pythonImportsCheck = [ "pefile" ];

  meta = with lib; {
    description = "Multi-platform Python module to parse and work with Portable Executable (aka PE) files";
    homepage = "https://github.com/erocarrera/pefile";
    license = licenses.mit;
    maintainers = [ maintainers.pamplemousse ];
  };
}
