{ stdenv, fetchFromGitHub, python2Packages}:

let
  pname = "cxxtest";
  version = "4.4";
in python2Packages.buildPythonApplication rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "CxxTest";
    repo = pname;
    rev = version;
    sha256 = "19w92kipfhp5wvs47l0qpibn3x49sbmvkk91yxw6nwk6fafcdl17";
  };

  sourceRoot = "${name}-src/python";

  meta = with stdenv.lib; {
    homepage = http://cxxtest.com;
    description = "Unit testing framework for C++";
    platforms = platforms.unix ;
    license = licenses.lgpl3;
    maintainers = [ maintainers.juliendehos ];
  };
}

