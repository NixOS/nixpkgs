{ stdenv, buildPythonPackage, fetchFromGitHub
, setuptools_scm, pytest, cmake
}:

buildPythonPackage rec {
  pname = "pytest-datadir";
  version = "1.3.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "gabrielcnr";
    repo = pname;
    rev = version;
    sha256 = "0kwgp6sqnqnmww5r0dkmyfpi0lmw0iwxz3fnwn2fs8w6bvixzznf";
  };

  nativeBuildInputs = [ setuptools_scm ];

  preBuild = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="${version}"
  '';

  checkInputs = [ pytest ];
  checkPhase = "pytest";

  meta = with stdenv.lib; {
    homepage = "https://github.com/gabrielcnr/pytest-datadir";
    description = "pytest plugin for manipulating test data directories and files";
    license = licenses.mit;
    maintainers = with maintainers; [ metadark ];
  };
}
