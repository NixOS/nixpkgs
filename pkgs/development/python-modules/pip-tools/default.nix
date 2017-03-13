{ stdenv, fetchFromGitHub, buildPythonPackage, pip, pytest, click, six, first, glibcLocales }:
buildPythonPackage rec {
  pname = "pip-tools";
  version = "1.8.1rc3";
  name = "pip-tools-${version}";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "pip-tools";
    rev = version;
    sha256 = "09rbgzj71bfp1x1jfr1zx3vax4qjbw5l6vcd3fqvshsdvg9lcnpx";
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
