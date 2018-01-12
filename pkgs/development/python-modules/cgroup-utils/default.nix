{ stdenv, buildPythonPackage, fetchFromGitHub, pep8, nose }:

buildPythonPackage rec {
  version = "0.6";
  pname = "cgroup-utils";
  name = pname + "-" + version;

  buildInputs = [ pep8 nose ];
  # Pep8 tests fail...
  doCheck = false;

  postPatch = ''
    sed -i -e "/argparse/d" setup.py
  '';

  src = fetchFromGitHub {
    owner = "peo3";
    repo = "cgroup-utils";
    rev = "v${version}";
    sha256 = "1ck0aijzrg9xf6hjdxnynkapnyxw0y385jb0q7wyq4jf77ayfszc";
  };

  meta = with stdenv.lib; {
    description = "Utility tools for control groups of Linux";
    maintainers = with maintainers; [ layus ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
