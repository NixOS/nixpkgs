{ stdenv, fetchFromGitHub, python2Packages}:

python2Packages.buildPythonApplication rec {
  version = "4.4";
  pname = "cxxtest";

  src = fetchFromGitHub {
    owner = "CxxTest";
    repo = pname;
    rev = version;
    sha256 = "19w92kipfhp5wvs47l0qpibn3x49sbmvkk91yxw6nwk6fafcdl17";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */python)
  '';

  meta = with stdenv.lib; {
    homepage = http://cxxtest.com;
    description = "Unit testing framework for C++";
    platforms = platforms.unix ;
    license = licenses.lgpl3;
    maintainers = [ maintainers.juliendehos ];
  };
}

