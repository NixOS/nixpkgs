{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:
let
  tagVersion = "2.2019-12-21";
in
buildPythonPackage {
  pname = "publicsuffix2";
  # tags have dashes, while the library version does not
  # see https://github.com/nexB/python-publicsuffix2/issues/12
  version = lib.replaceStrings [ "-" ] [ "" ] tagVersion;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "python-publicsuffix2";
    rev = "release-${tagVersion}";
    hash = "sha256-OV0O4LLxQ2LQiEHc1JTvScu35o2IWxo/hgn/COh2e7Y=";
  };

  build-system = [ setuptools ];

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
    maintainers = [ ];
  };
}
