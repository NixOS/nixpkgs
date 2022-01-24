{ lib, buildPythonPackage, fetchFromGitHub, requests }:

buildPythonPackage rec {
  pname = "publicsuffix2";
  version = "2.20191221";

  # Tests are missing in the sdist
  # See: https://github.com/nexB/python-publicsuffix2/issues/12
  src = fetchFromGitHub {
    owner = "nexB";
    repo = "python-publicsuffix2";
    rev = "release-2.2019-12-21";
    sha256 = "1dkvfvl0izq9hqzilnw8ipkbgjs9xyad9p21i3864hzinbh0wp9r";
  };

  nativeBuildInputs = [ requests ];

  meta = with lib; {
    description = ''
      Get a public suffix for a domain name using the Public Suffix
      List. Forked from and using the same API as the publicsuffix package.
    '';
    homepage = "https://pypi.python.org/pypi/publicsuffix2/";
    license = licenses.mpl20;
  };
}
