{ lib, buildPythonPackage, fetchFromGitHub }:
let
  tagVersion = "2.2019-12-21";
in
buildPythonPackage {
  pname = "publicsuffix2";
  # tags have dashes, while the library version does not
  # see https://github.com/nexB/python-publicsuffix2/issues/12
  version = lib.replaceStrings ["-"] [""] tagVersion;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "python-publicsuffix2";
    rev = "release-${tagVersion}";
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
    maintainers = with maintainers; [ ];
  };
}
