{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cymem";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "cymem";
    rev = "v${version}";
    sha256 = "sha256-o+44v6wvE9HxeQaDDQ0+gi7z1V7jtkZvWglY8UyVHLg=";
  };

  propagatedBuildInputs = [
    cython
  ];

  # ModuleNotFoundError: No module named 'cymem.cymem'
  doCheck = false;

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "cymem" ];

  meta = with lib; {
    description = "Cython memory pool for RAII-style memory management";
    homepage = "https://github.com/explosion/cymem";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
