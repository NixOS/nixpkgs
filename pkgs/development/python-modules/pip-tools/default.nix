{ stdenv, fetchFromGitHub, buildPythonPackage, pip, pytest, click, six, first, glibcLocales }:
buildPythonPackage rec {
  pname = "pip-tools";
  version = "1.9.0";
  name = "pip-tools-${version}";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "pip-tools";
    rev = version;
    sha256 = "0706feb27263a2dade6d39cc508e718282bd08f455d0643f251659f905be4d56";
  };

  LC_ALL = "en_US.UTF-8";
  buildInputs = [ pytest glibcLocales ];
  propagatedBuildInputs = [ pip click six first ];

  checkPhase = ''
    export HOME=$(mktemp -d)
    py.test -k "not test_realistic_complex_sub_dependencies" # requires network
  '';

  meta = with stdenv.lib; {
    description = "Keeps your pinned dependencies fresh";
    homepage = https://github.com/jazzband/pip-tools/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ zimbatm ];
  };
}
