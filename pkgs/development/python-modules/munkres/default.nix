{ stdenv
, buildPythonPackage
, fetchFromGitHub
, nose
}:

buildPythonPackage rec {
  pname = "munkres";
  version = "1.0.12";

  # No sdist for 1.0.12, see https://github.com/bmc/munkres/issues/25
  src = fetchFromGitHub {
    owner = "bmc";
    repo = pname;
    rev = "release-${version}";
    sha256 = "0m3rkn0z3ialndxmyg26xn081znna34i5maa1i4nkhy6nf0ixdjm";
  };

  checkInputs = [ nose ];

  checkPhase = "nosetests";

  meta = with stdenv.lib; {
    homepage = http://bmc.github.com/munkres/;
    description = "Munkres algorithm for the Assignment Problem";
    license = licenses.bsd3;
    maintainers = with maintainers; [ domenkozar ];
  };

}
