{ stdenv, buildPythonPackage, fetchFromGitHub, pymeeus, pytz }:

buildPythonPackage rec {
  pname = "convertdate";
  version = "2.2.0";

  # Tests are not available in the PyPI tarball so use GitHub instead.
  src = fetchFromGitHub {
    owner = "fitnr";
    repo = pname;
    rev = "v${version}";
    sha256 = "04j8k7a9qndmawy3m345py74y18hw7lb6gc0qp0mr8d68x99xjq0";
  };

  propagatedBuildInputs = [ pymeeus pytz ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/fitnr/convertdate";
    description = "Utils for converting between date formats and calculating holidays";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
