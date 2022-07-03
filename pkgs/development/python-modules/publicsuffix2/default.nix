{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "publicsuffix2";
  version = "2.2019-12-21";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "python-publicsuffix2";
    rev = "release-${version}";
    sha256 = "1dkvfvl0izq9hqzilnw8ipkbgjs9xyad9p21i3864hzinbh0wp9r";
  };

  postPatch = ''
    # only used to update the interal publicsuffix list
    substituteInPlace setup.py \
      --replace "'requests >= 2.7.0'," ""
  '';

  pythonImportsCheck = [ "publicsuffix2" ];

  meta = with lib; {
    description = "Get a public suffix for a domain name using the Public Suffix List";
    homepage = "https://github.com/nexB/python-publicsuffix2";
    license = licenses.mpl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
