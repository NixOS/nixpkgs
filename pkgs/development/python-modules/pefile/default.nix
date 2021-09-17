{ lib
, buildPythonPackage
, future
, fetchFromGitHub
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pefile";
  version = "2021.9.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "erocarrera";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pgsw84i9r6ydkfzqifgl5lvcz3cf3xz5c2543kl3q8mgb21wxaz";
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
